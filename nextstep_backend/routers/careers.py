"""
Careers router — list, detail, domains, clusters, compare.

GET  /api/v1/careers/
GET  /api/v1/careers/{slug}/
GET  /api/v1/careers/domains/
GET  /api/v1/careers/domains/{slug}/
GET  /api/v1/careers/clusters/
GET  /api/v1/careers/compare/
"""

from uuid import UUID

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select, func, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from core.database import get_db
from core.dependencies import get_current_user
from core.exceptions import NexStepException
from core.pagination import PageParam, PageSizeParam, paginate_query_params, build_pagination_urls
from models.user import User
from models.career import Career, CareerDomain, CareerCluster
from models.recommendation import CareerSave
from schemas.career import (
    CareerListItem, CareerDetailOut, CareerDomainOut, CareerDomainBrief,
    CareerClusterOut, CareerCompareResult, CareerCompareItem,
)


router = APIRouter()


def _format_salary_lpa(min_paise: int | None, max_paise: int | None) -> str | None:
    """Convert paise range to '4–8' LPA string."""
    if min_paise is None and max_paise is None:
        return None
    low = int(min_paise / 100000) if min_paise else 0
    high = int(max_paise / 100000) if max_paise else 0
    return f"{low}–{high}"


@router.get("/")
async def list_careers(
    search: str | None = None,
    domain_slug: str | None = None,
    dimension_tags: str | None = None,
    india_viability: str | None = None,
    future_score_min: int | None = Query(None, ge=1, le=10),
    is_emerging: bool | None = None,
    ordering: str = "-future_score",
    page: PageParam = 1,
    page_size: PageSizeParam = 20,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """List careers with filtering, sorting, and search."""
    query = select(Career).options(selectinload(Career.domain)).where(Career.is_active == True)

    # Filters
    if search:
        search_term = f"%{search}%"
        query = query.where(
            or_(
                Career.name.ilike(search_term),
                Career.one_liner.ilike(search_term),
            )
        )
    if domain_slug:
        query = query.join(CareerDomain).where(CareerDomain.slug == domain_slug)
    if dimension_tags:
        tags = [t.strip() for t in dimension_tags.split(",")]
        query = query.where(Career.dimension_tags.overlap(tags))
    if india_viability:
        query = query.where(Career.india_viability == india_viability)
    if future_score_min is not None:
        query = query.where(Career.future_score >= future_score_min)
    if is_emerging is not None:
        query = query.where(Career.is_emerging == is_emerging)

    # Count
    count_query = select(func.count()).select_from(query.subquery())
    total_count = (await db.execute(count_query)).scalar() or 0

    # Ordering
    if ordering == "future_score":
        query = query.order_by(Career.future_score.asc())
    elif ordering == "-future_score":
        query = query.order_by(Career.future_score.desc())
    elif ordering == "name":
        query = query.order_by(Career.name.asc())
    else:
        query = query.order_by(Career.future_score.desc())

    # Pagination
    offset, limit = paginate_query_params(page, page_size)
    query = query.offset(offset).limit(limit)

    result = await db.execute(query)
    careers = result.scalars().all()

    next_url, prev_url = build_pagination_urls("/api/v1/careers/", page, page_size, total_count)

    results = []
    for c in careers:
        results.append({
            "id": str(c.id),
            "slug": c.slug,
            "name": c.name,
            "one_liner": c.one_liner,
            "domain": {
                "id": str(c.domain.id),
                "slug": c.domain.slug,
                "name": c.domain.name,
                "short_name": c.domain.short_name,
            },
            "dimension_tags": c.dimension_tags,
            "india_viability": c.india_viability,
            "future_score": c.future_score,
            "is_emerging": c.is_emerging,
            "salary_entry_lpa": _format_salary_lpa(c.salary_entry_min_paise, c.salary_entry_max_paise),
            "salary_mid_lpa": _format_salary_lpa(c.salary_mid_min_paise, c.salary_mid_max_paise),
            "salary_senior_lpa": _format_salary_lpa(c.salary_senior_min_paise, c.salary_senior_max_paise),
        })

    return {
        "success": True,
        "data": {
            "count": total_count,
            "next": next_url,
            "previous": prev_url,
            "results": results,
        },
    }


@router.get("/domains/")
async def list_domains(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """List all career domains."""
    stmt = select(CareerDomain).where(CareerDomain.is_active == True).order_by(CareerDomain.display_order)
    result = await db.execute(stmt)
    domains = result.scalars().all()

    data = []
    for d in domains:
        # Count careers in this domain
        count_stmt = select(func.count()).where(Career.domain_id == d.id, Career.is_active == True)
        count = (await db.execute(count_stmt)).scalar() or 0
        data.append({
            "id": str(d.id),
            "slug": d.slug,
            "name": d.name,
            "short_name": d.short_name,
            "india_relevance": d.india_relevance,
            "growth_forecast_2035": d.growth_forecast_2035,
            "entry_path_summary": d.entry_path_summary,
            "career_count": count,
            "display_order": d.display_order,
        })

    return {"success": True, "data": data}


@router.get("/domains/{slug}/")
async def get_domain_detail(
    slug: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Domain with all its careers."""
    stmt = select(CareerDomain).where(CareerDomain.slug == slug)
    result = await db.execute(stmt)
    domain = result.scalar_one_or_none()
    if not domain:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Domain not found.", http_status=404)

    careers_stmt = select(Career).where(Career.domain_id == domain.id, Career.is_active == True)
    careers_result = await db.execute(careers_stmt)
    careers = careers_result.scalars().all()

    return {
        "success": True,
        "data": {
            "id": str(domain.id),
            "slug": domain.slug,
            "name": domain.name,
            "short_name": domain.short_name,
            "careers": [
                {"slug": c.slug, "name": c.name, "one_liner": c.one_liner, "future_score": c.future_score}
                for c in careers
            ],
        },
    }


@router.get("/clusters/")
async def list_clusters(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """All career clusters."""
    stmt = select(CareerCluster)
    result = await db.execute(stmt)
    clusters = result.scalars().all()

    data = []
    for cl in clusters:
        domain_count = len(cl.domain_ids) if cl.domain_ids else 0
        data.append({
            "id": str(cl.id),
            "name": cl.name,
            "q24_description": cl.q24_description,
            "domain_count": domain_count,
            "career_count": 0,  # Would need aggregation
        })

    return {"success": True, "data": data}


@router.get("/compare/")
async def compare_careers(
    slugs: str = Query(..., description="Comma-separated career slugs (2-3)"),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Side-by-side comparison of 2-3 careers."""
    slug_list = [s.strip() for s in slugs.split(",")]
    if len(slug_list) < 2 or len(slug_list) > 3:
        raise NexStepException(code="VALIDATION_ERROR", message="Provide 2-3 career slugs.", http_status=422)

    stmt = select(Career).where(Career.slug.in_(slug_list))
    result = await db.execute(stmt)
    careers = result.scalars().all()

    items = []
    for c in careers:
        items.append({
            "slug": c.slug,
            "name": c.name,
            "dimension_tags": c.dimension_tags,
            "future_score": c.future_score,
            "india_viability": c.india_viability,
            "salary_entry_lpa": _format_salary_lpa(c.salary_entry_min_paise, c.salary_entry_max_paise),
            "salary_mid_lpa": _format_salary_lpa(c.salary_mid_min_paise, c.salary_mid_max_paise),
            "salary_senior_lpa": _format_salary_lpa(c.salary_senior_min_paise, c.salary_senior_max_paise),
            "user_skill_overlap_count": 0,
            "user_skill_overlap": [],
            "work_style": None,
            "time_to_first_job_months": None,
            "entry_difficulty": None,
        })

    return {
        "success": True,
        "data": {
            "careers": items,
            "comparison_dimensions": ["salary", "future_score", "skill_overlap", "entry_difficulty", "india_viability"],
        },
    }


@router.get("/{slug}/")
async def get_career_detail(
    slug: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Full career detail page."""
    stmt = select(Career).options(selectinload(Career.domain)).where(Career.slug == slug)
    result = await db.execute(stmt)
    career = result.scalar_one_or_none()

    if not career:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Career not found.", http_status=404)

    # Check if saved
    save_stmt = select(CareerSave).where(CareerSave.user_id == current_user.id, CareerSave.career_id == career.id)
    save_result = await db.execute(save_stmt)
    is_saved = save_result.scalar_one_or_none() is not None

    # Fetch related careers
    related = []
    if career.related_career_ids:
        rel_stmt = select(Career).where(Career.id.in_(career.related_career_ids))
        rel_result = await db.execute(rel_stmt)
        for rc in rel_result.scalars().all():
            related.append({"slug": rc.slug, "name": rc.name, "one_liner": rc.one_liner, "future_score": rc.future_score})

    return {
        "success": True,
        "data": {
            "id": str(career.id),
            "slug": career.slug,
            "name": career.name,
            "one_liner": career.one_liner,
            "domain": {
                "id": str(career.domain.id),
                "slug": career.domain.slug,
                "name": career.domain.name,
                "short_name": career.domain.short_name,
            },
            "dimension_tags": career.dimension_tags,
            "india_viability": career.india_viability,
            "future_score": career.future_score,
            "future_score_reasoning": career.future_score_reasoning,
            "typical_day": career.typical_day,
            "skills_needed": career.skills_needed,
            "entry_paths": career.entry_paths,
            "salary_entry_lpa": _format_salary_lpa(career.salary_entry_min_paise, career.salary_entry_max_paise),
            "salary_mid_lpa": _format_salary_lpa(career.salary_mid_min_paise, career.salary_mid_max_paise),
            "salary_senior_lpa": _format_salary_lpa(career.salary_senior_min_paise, career.salary_senior_max_paise),
            "is_emerging": career.is_emerging,
            "last_reviewed_at": career.last_reviewed_at,
            "related_careers": related,
            "is_saved": is_saved,
            "user_match_score": None,
        },
    }
