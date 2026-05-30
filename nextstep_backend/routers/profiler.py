"""
Profiler router — questions, sessions, responses, completion.

GET  /api/v1/profiler/questions/
POST /api/v1/profiler/sessions/
GET  /api/v1/profiler/sessions/{session_id}/
POST /api/v1/profiler/sessions/{session_id}/responses/
POST /api/v1/profiler/sessions/{session_id}/complete/
GET  /api/v1/profiler/profile/
"""

import json
from pathlib import Path
from datetime import datetime, timezone
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.dependencies import get_current_user
from core.exceptions import NexStepException
from models.user import User, StudentProfile
from models.profiler import ProfilerSession, ProfilerResponse, InterestProfile
from schemas.profiler import (
    ProfilerQuestion, ProfilerSessionOut,
    ProfilerResponsesRequest, ProfilerResponsesResult,
    SessionCompleteResult, InterestProfileOut,
)
from services.scoring_engine import compute_dimension_scores


router = APIRouter()

# Load question bank once at module level
_questions_path = Path(__file__).parent.parent / "data" / "questions.json"


def _load_questions():
    if _questions_path.exists():
        with open(_questions_path, "r") as f:
            return json.load(f)
    return []


@router.get("/questions/")
async def get_profiler_questions(
    current_user: User = Depends(get_current_user),
):
    """Get full profiler questions set."""
    questions = _load_questions()
    return {"success": True, "data": questions}


@router.post("/sessions/", status_code=201)
async def start_session(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Start a new profiler session."""
    # Count existing sessions for this user
    stmt = select(ProfilerSession).where(ProfilerSession.user_id == current_user.id)
    result = await db.execute(stmt)
    existing = result.scalars().all()
    session_number = len(existing) + 1

    questions = _load_questions()
    total_questions = len(questions)

    session = ProfilerSession(
        user_id=current_user.id,
        session_number=session_number,
        total_questions=total_questions,
    )
    db.add(session)
    await db.flush()

    return {
        "success": True,
        "data": {
            "session_id": str(session.id),
            "session_number": session.session_number,
            "status": session.status,
            "total_questions": session.total_questions,
            "questions_answered": 0,
            "started_at": session.started_at,
        },
    }


@router.get("/sessions/{session_id}/")
async def get_session(
    session_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get session progress."""
    session = await db.get(ProfilerSession, session_id)
    if not session or session.user_id != current_user.id:
        raise NexStepException(
            code="PROFILER_SESSION_NOT_FOUND",
            message="No active profiler session found for this user.",
            http_status=404,
        )

    # Find last answered code
    stmt = (
        select(ProfilerResponse.question_code)
        .where(ProfilerResponse.session_id == session_id)
        .order_by(ProfilerResponse.answered_at.desc())
        .limit(1)
    )
    result = await db.execute(stmt)
    last_code = result.scalar_one_or_none()

    return {
        "success": True,
        "data": {
            "session_id": str(session.id),
            "session_number": session.session_number,
            "status": session.status,
            "total_questions": session.total_questions,
            "questions_answered": session.questions_answered,
            "questions_skipped": session.questions_skipped,
            "last_answered_code": last_code,
            "started_at": session.started_at,
        },
    }


@router.post("/sessions/{session_id}/responses/")
async def submit_responses(
    session_id: UUID,
    body: ProfilerResponsesRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Submit one or more responses."""
    session = await db.get(ProfilerSession, session_id)
    if not session or session.user_id != current_user.id:
        raise NexStepException(
            code="PROFILER_SESSION_NOT_FOUND",
            message="No active profiler session found for this user.",
            http_status=404,
        )

    # Load questions to get dimension weights
    questions = _load_questions()
    questions_map = {q["code"]: q for q in questions}

    answered_count = 0
    skipped_count = 0

    for resp in body.responses:
        # Look up dimension weights from the question bank
        q = questions_map.get(resp.question_code, {})
        options = q.get("options", [])

        # Accumulate weights from selected options
        combined_weights = {}
        for idx in resp.selected_option_index:
            if 0 <= idx < len(options):
                for dim, weight in options[idx].get("dimension_weights", {}).items():
                    combined_weights[dim] = combined_weights.get(dim, 0) + weight

        pr = ProfilerResponse(
            session_id=session_id,
            question_code=resp.question_code,
            question_section=resp.question_section,
            selected_option_index=resp.selected_option_index,
            dimension_weights=combined_weights,
            skipped=resp.skipped,
        )
        db.add(pr)

        if resp.skipped:
            skipped_count += 1
        else:
            answered_count += 1

    session.questions_answered += answered_count
    session.questions_skipped += skipped_count
    await db.flush()

    progress = int((session.questions_answered / max(session.total_questions, 1)) * 100)

    return {
        "success": True,
        "data": {
            "session_id": str(session.id),
            "questions_answered": session.questions_answered,
            "questions_skipped": session.questions_skipped,
            "progress_percent": progress,
        },
    }


@router.post("/sessions/{session_id}/complete/")
async def complete_session(
    session_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Finalize the session and compute scores."""
    session = await db.get(ProfilerSession, session_id)
    if not session or session.user_id != current_user.id:
        raise NexStepException(
            code="PROFILER_SESSION_NOT_FOUND",
            message="No active profiler session found for this user.",
            http_status=404,
        )

    now = datetime.now(timezone.utc)

    # 1. Mark session complete
    time_taken = int((now - session.started_at.replace(tzinfo=timezone.utc)).total_seconds()) if session.started_at else 0
    session.status = "completed"
    session.completed_at = now
    session.time_taken_seconds = time_taken

    # 2. Compute dimension scores
    dimension_scores = await compute_dimension_scores(db, session_id)

    # 3. Determine top dimensions
    sorted_dims = sorted(dimension_scores.items(), key=lambda x: x[1], reverse=True)
    top_dimensions = [d[0] for d in sorted_dims[:3]]

    # 4. Deactivate previous profiles
    await db.execute(
        update(InterestProfile)
        .where(InterestProfile.user_id == current_user.id, InterestProfile.is_active == True)
        .values(is_active=False)
    )

    # 5. Create new interest profile
    profile = InterestProfile(
        user_id=current_user.id,
        session_id=session_id,
        is_active=True,
        dimension_scores=dimension_scores,
        top_dimensions=top_dimensions,
        career_cluster_weights={},
    )
    db.add(profile)

    # 6. Mark student profile as completed
    stmt = select(StudentProfile).where(StudentProfile.user_id == current_user.id)
    result = await db.execute(stmt)
    student_profile = result.scalar_one_or_none()
    if student_profile:
        student_profile.profiler_completed = True
        student_profile.profiler_completed_at = now

    # 7. Generate Recommendations
    from services.matching_engine import compute_match_score
    from models.recommendation import CareerRecommendation
    from models.career import Career
    
    careers_stmt = select(Career).where(Career.is_active == True)
    careers_result = await db.execute(careers_stmt)
    all_careers = careers_result.scalars().all()

    scored = []
    for c in all_careers:
        score, tier, overlap = compute_match_score(
            dimension_scores, c.dimension_tags, top_dimensions
        )
        scored.append((c, score, tier, overlap))

    # Sort by score desc, take top 15
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
        "data": {
            "session_id": str(session.id),
            "status": "completed",
            "time_taken_seconds": time_taken,
            "interest_profile": {
                "id": str(profile.id),
                "dimension_scores": dimension_scores,
                "top_dimensions": top_dimensions,
                "computed_at": profile.computed_at,
            },
            "recommendations_ready": True,
            "recommendations_eta_seconds": 0,
        },
    }


@router.get("/profile/")
async def get_active_profile(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get active interest profile for the current user."""
    stmt = (
        select(InterestProfile)
        .where(
            InterestProfile.user_id == current_user.id,
            InterestProfile.is_active == True,
        )
        .order_by(InterestProfile.computed_at.desc())
        .limit(1)
    )
    result = await db.execute(stmt)
    profile = result.scalar_one_or_none()

    if not profile:
        raise NexStepException(
            code="PROFILER_NOT_COMPLETED",
            message="Complete the interest profiler to see your profile.",
            http_status=422,
        )

    return {
        "success": True,
        "data": InterestProfileOut.model_validate(profile).model_dump(),
    }
