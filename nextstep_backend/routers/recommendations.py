"""
Recommendations router — list, regenerate, saved careers, career views.

GET   /api/v1/recommendations/
POST  /api/v1/recommendations/regenerate/
GET   /api/v1/recommendations/saved/
POST  /api/v1/careers/{slug}/save/
DELETE /api/v1/careers/{slug}/save/
PATCH /api/v1/careers/{slug}/save/
POST  /api/v1/careers/{slug}/view/
"""

from uuid import UUID
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, Query, status
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from core.database import get_db
from core.dependencies import get_current_user
from core.exceptions import NexStepException
from models.user import User
from models.career import Career
from models.profiler import InterestProfile
from models.recommendation import CareerRecommendation, CareerSave, CareerView
from schemas.recommendation import (
    CareerSaveRequest, CareerSaveUpdateRequest,
    CareerViewRequest,
)


router = APIRouter()


def _format_salary_lpa(min_p, max_p):
    if min_p is None and max_p is None:
        return None
    return f"{int((min_p or 0) / 100000)}–{int((max_p or 0) / 100000)}"


@router.get("/")
async def list_recommendations(
    tier: str | None = None,
    limit: int = Query(15, ge=1, le=30),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Personalized career matches for the current user."""
    # Get active interest profile
    ip_stmt = select(InterestProfile).where(
        InterestProfile.user_id == current_user.id,
        InterestProfile.is_active == True,
    )
    ip_result = await db.execute(ip_stmt)
    profile = ip_result.scalar_one_or_none()

    if not profile:
        raise NexStepException(
            code="PROFILER_NOT_COMPLETED",
            message="Complete the interest profiler to see your career matches.",
            http_status=422,
        )

    query = (
        select(CareerRecommendation)
        .options(selectinload(CareerRecommendation.career).selectinload(Career.domain))
        .where(CareerRecommendation.interest_profile_id == profile.id)
    )

    if tier:
        query = query.where(CareerRecommendation.match_tier == tier)

    query = query.order_by(CareerRecommendation.display_rank.asc()).limit(limit)
    result = await db.execute(query)
    recs = result.scalars().all()

    recommendations = []
    for r in recs:
        c = r.career
        recommendations.append({
            "rank": r.display_rank,
            "match_score": r.match_score,
            "match_tier": r.match_tier,
            "tag_overlap_count": r.tag_overlap_count,
            "is_novel": r.is_novel,
            "career": {
                "slug": c.slug,
                "name": c.name,
                "one_liner": c.one_liner,
                "dimension_tags": c.dimension_tags,
                "domain_short_name": c.domain.short_name if c.domain else "",
                "future_score": c.future_score,
                "india_viability": c.india_viability,
                "salary_entry_lpa": _format_salary_lpa(c.salary_entry_min_paise, c.salary_entry_max_paise),
                "is_emerging": c.is_emerging,
            },
        })

    return {
        "success": True,
        "data": {
            "interest_profile_id": str(profile.id),
            "generated_at": profile.computed_at,
            "total_matches": len(recommendations),
            "recommendations": recommendations,
        },
    }


@router.post("/regenerate/")
async def regenerate_recommendations(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Force-regenerate recommendations."""
    # 1. Fetch active interest profile
    ip_stmt = select(InterestProfile).where(
        InterestProfile.user_id == current_user.id,
        InterestProfile.is_active == True,
    )
    ip_result = await db.execute(ip_stmt)
    profile = ip_result.scalar_one_or_none()

    if not profile:
        raise NexStepException(
            code="PROFILER_NOT_COMPLETED",
            message="Complete the interest profiler to see your career matches.",
            http_status=422,
        )

    # 2. Delete existing recommendations
    from sqlalchemy import delete
    await db.execute(delete(CareerRecommendation).where(CareerRecommendation.interest_profile_id == profile.id))

    # 3. Generate Recommendations
    from services.matching_engine import compute_match_score
    
    careers_stmt = select(Career).where(Career.is_active == True)
    careers_result = await db.execute(careers_stmt)
    all_careers = careers_result.scalars().all()

    scored = []
    for c in all_careers:
        score, tier, overlap = compute_match_score(
            profile.dimension_scores, c.dimension_tags, profile.top_dimensions
        )
        scored.append((c, score, tier, overlap))

    # Sort by score desc
    scored.sort(key=lambda x: x[1], reverse=True)
    top_recs = scored[:15]

    for rank, (career, score, tier, overlap) in enumerate(top_recs, start=1):
        rec = CareerRecommendation(
            user_id=current_user.id,
            interest_profile_id=profile.id,
            career_id=career.id,
            match_score=score,
            match_tier=tier,
            tag_overlap_count=overlap,
            display_rank=rank,
            is_novel=(tier == "discovery_match"),
        )
        db.add(rec)

    await db.flush()

    return {
        "success": True,
        "data": {"status": "completed", "eta_seconds": 0},
    }


@router.get("/saved/")
async def list_saved_careers(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get all bookmarked careers."""
    stmt = (
        select(CareerSave)
        .options(selectinload(CareerSave.career).selectinload(Career.domain))
        .where(CareerSave.user_id == current_user.id)
        .order_by(CareerSave.saved_at.desc())
    )
    result = await db.execute(stmt)
    saves = result.scalars().all()

    results = []
    for s in saves:
        c = s.career
        results.append({
            "save_id": str(s.id),
            "saved_at": s.saved_at,
            "notes": s.notes,
            "career": {
                "slug": c.slug,
                "name": c.name,
                "future_score": c.future_score,
                "domain_short_name": c.domain.short_name if c.domain else "",
                "salary_entry_lpa": _format_salary_lpa(c.salary_entry_min_paise, c.salary_entry_max_paise),
            },
        })

    return {"success": True, "data": {"count": len(results), "results": results}}
