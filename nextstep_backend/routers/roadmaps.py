"""
Roadmaps router — list, create, detail, step progress, summary.

GET   /api/v1/roadmaps/
POST  /api/v1/roadmaps/
GET   /api/v1/roadmaps/{roadmap_id}/
PATCH /api/v1/roadmaps/{roadmap_id}/steps/{step_id}/progress/
GET   /api/v1/roadmaps/progress-summary/
"""

from uuid import UUID
from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from core.database import get_db
from core.dependencies import get_current_user
from core.exceptions import NexStepException
from models.user import User, StudentProfile
from models.career import Career
from models.profiler import InterestProfile
from models.roadmap import Roadmap, RoadmapStep, RoadmapStepProgress
from schemas.roadmap import RoadmapCreateRequest, StepProgressUpdateRequest


router = APIRouter()


@router.get("/")
async def list_roadmaps(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """List all roadmaps for the current user."""
    stmt = (
        select(Roadmap)
        .options(selectinload(Roadmap.career), selectinload(Roadmap.steps))
        .where(Roadmap.user_id == current_user.id, Roadmap.is_active == True)
        .order_by(Roadmap.generated_at.desc())
    )
    result = await db.execute(stmt)
    roadmaps = result.scalars().all()

    data = []
    for rm in roadmaps:
        total = len(rm.steps)
        # Count completed steps
        prog_stmt = select(func.count()).where(
            RoadmapStepProgress.roadmap_step_id.in_([s.id for s in rm.steps]),
            RoadmapStepProgress.user_id == current_user.id,
            RoadmapStepProgress.status == "completed",
        )
        completed = (await db.execute(prog_stmt)).scalar() or 0

        data.append({
            "id": str(rm.id),
            "career": {
                "slug": rm.career.slug,
                "name": rm.career.name,
                "domain_short_name": rm.career.domain.short_name if rm.career.domain else "",
            } if rm.career else {},
            "academic_stage": rm.academic_stage,
            "generation_method": rm.generation_method,
            "is_active": rm.is_active,
            "total_steps": total,
            "completed_steps": completed,
            "completion_percent": int((completed / max(total, 1)) * 100),
            "generated_at": rm.generated_at,
        })

    return {"success": True, "data": data}


@router.post("/", status_code=201)
async def create_roadmap(
    body: RoadmapCreateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Generate a roadmap for a specific career."""
    # Find career
    stmt = select(Career).where(Career.slug == body.career_slug)
    result = await db.execute(stmt)
    career = result.scalar_one_or_none()
    if not career:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Career not found.", http_status=404)

    # Check for existing active roadmap
    existing_stmt = select(Roadmap).where(
        Roadmap.user_id == current_user.id,
        Roadmap.career_id == career.id,
        Roadmap.is_active == True,
    )
    existing = (await db.execute(existing_stmt)).scalar_one_or_none()
    if existing:
        raise NexStepException(
            code="ROADMAP_ALREADY_EXISTS",
            message="Active roadmap for this career already exists.",
            http_status=409,
        )

    # Get student profile for academic stage
    sp_stmt = select(StudentProfile).where(StudentProfile.user_id == current_user.id)
    sp = (await db.execute(sp_stmt)).scalar_one_or_none()
    academic_stage = sp.academic_stage if sp else "grade_11_12_science"

    # Get active interest profile
    ip_stmt = select(InterestProfile).where(
        InterestProfile.user_id == current_user.id, InterestProfile.is_active == True
    )
    ip = (await db.execute(ip_stmt)).scalar_one_or_none()
    if not ip:
        raise NexStepException(code="PROFILER_NOT_COMPLETED", message="Complete the profiler first.", http_status=422)

    # Create roadmap
    roadmap = Roadmap(
        user_id=current_user.id,
        career_id=career.id,
        interest_profile_id=ip.id,
        academic_stage=academic_stage,
        generation_method="template",
    )
    db.add(roadmap)
    await db.flush()

    # Create template steps (placeholder — in production, loaded from templates)
    template_steps = [
        {"order": 1, "category": "first_30_days", "title": f"Research {career.name} career path", "description": "Spend time understanding what this career involves day-to-day.", "timeframe": "30 days"},
        {"order": 2, "category": "skill_to_learn", "title": f"Start building core skills for {career.name}", "description": "Begin with the foundational skills needed.", "timeframe": "60 days"},
        {"order": 3, "category": "project_to_build", "title": "Build a portfolio project", "description": "Create something tangible to demonstrate your skills.", "timeframe": "90 days"},
    ]

    steps = []
    for ts in template_steps:
        step = RoadmapStep(
            roadmap_id=roadmap.id,
            step_order=ts["order"],
            category=ts["category"],
            title=ts["title"],
            description=ts["description"],
            timeframe=ts["timeframe"],
        )
        db.add(step)
        steps.append(step)

    await db.flush()

    return {
        "success": True,
        "data": {
            "id": str(roadmap.id),
            "career": {"slug": career.slug, "name": career.name},
            "academic_stage": roadmap.academic_stage,
            "generation_method": roadmap.generation_method,
            "is_active": True,
            "generated_at": roadmap.generated_at,
            "steps": [
                {
                    "id": str(s.id),
                    "step_order": s.step_order,
                    "category": s.category,
                    "title": s.title,
                    "description": s.description,
                    "timeframe": s.timeframe,
                    "resource_url": s.resource_url,
                    "resource_label": s.resource_label,
                    "is_premium": s.is_premium,
                    "status": "not_started",
                    "completed_at": None,
                }
                for s in steps
            ],
        },
    }


@router.get("/progress-summary/")
async def progress_summary(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Summary across all roadmaps for the Progress Tracker dashboard."""
    stmt = (
        select(Roadmap)
        .options(selectinload(Roadmap.career), selectinload(Roadmap.steps))
        .where(Roadmap.user_id == current_user.id, Roadmap.is_active == True)
    )
    result = await db.execute(stmt)
    roadmaps = result.scalars().all()

    total_steps_all = 0
    completed_all = 0
    roadmap_items = []

    for rm in roadmaps:
        total = len(rm.steps)
        total_steps_all += total

        prog_stmt = select(func.count()).where(
            RoadmapStepProgress.roadmap_step_id.in_([s.id for s in rm.steps]),
            RoadmapStepProgress.user_id == current_user.id,
            RoadmapStepProgress.status == "completed",
        )
        completed = (await db.execute(prog_stmt)).scalar() or 0
        completed_all += completed

        roadmap_items.append({
            "id": str(rm.id),
            "career_name": rm.career.name if rm.career else "",
            "total_steps": total,
            "completed_steps": completed,
            "completion_percent": int((completed / max(total, 1)) * 100),
            "next_step": None,
        })

    return {
        "success": True,
        "data": {
            "active_roadmaps": len(roadmaps),
            "total_steps_across_all": total_steps_all,
            "completed_steps": completed_all,
            "overall_completion_percent": int((completed_all / max(total_steps_all, 1)) * 100),
            "roadmaps": roadmap_items,
            "interest_profile_summary": None,
            "top_3_matched_careers": [],
        },
    }


@router.get("/{roadmap_id}/")
async def get_roadmap(
    roadmap_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get a roadmap with all steps and progress."""
    stmt = (
        select(Roadmap)
        .options(selectinload(Roadmap.career), selectinload(Roadmap.steps))
        .where(Roadmap.id == roadmap_id, Roadmap.user_id == current_user.id)
    )
    result = await db.execute(stmt)
    roadmap = result.scalar_one_or_none()

    if not roadmap:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Roadmap not found.", http_status=404)

    # Get progress for all steps
    step_ids = [s.id for s in roadmap.steps]
    prog_stmt = select(RoadmapStepProgress).where(
        RoadmapStepProgress.roadmap_step_id.in_(step_ids),
        RoadmapStepProgress.user_id == current_user.id,
    )
    prog_result = await db.execute(prog_stmt)
    progress_map = {p.roadmap_step_id: p for p in prog_result.scalars().all()}

    steps_data = []
    for s in sorted(roadmap.steps, key=lambda x: x.step_order):
        prog = progress_map.get(s.id)
        steps_data.append({
            "id": str(s.id),
            "step_order": s.step_order,
            "category": s.category,
            "title": s.title,
            "description": s.description,
            "timeframe": s.timeframe,
            "resource_url": s.resource_url,
            "resource_label": s.resource_label,
            "is_premium": s.is_premium,
            "status": prog.status if prog else "not_started",
            "completed_at": prog.completed_at if prog else None,
        })

    return {
        "success": True,
        "data": {
            "id": str(roadmap.id),
            "career": {"slug": roadmap.career.slug, "name": roadmap.career.name} if roadmap.career else {},
            "academic_stage": roadmap.academic_stage,
            "generation_method": roadmap.generation_method,
            "is_active": roadmap.is_active,
            "generated_at": roadmap.generated_at,
            "steps": steps_data,
        },
    }


@router.patch("/{roadmap_id}/steps/{step_id}/progress/")
async def update_step_progress(
    roadmap_id: UUID,
    step_id: UUID,
    body: StepProgressUpdateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Update progress on a roadmap step."""
    # Verify step belongs to roadmap and user
    step_stmt = (
        select(RoadmapStep)
        .join(Roadmap)
        .where(RoadmapStep.id == step_id, Roadmap.id == roadmap_id, Roadmap.user_id == current_user.id)
    )
    step = (await db.execute(step_stmt)).scalar_one_or_none()
    if not step:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Step not found.", http_status=404)

    # Get or create progress
    prog_stmt = select(RoadmapStepProgress).where(
        RoadmapStepProgress.user_id == current_user.id,
        RoadmapStepProgress.roadmap_step_id == step_id,
    )
    progress = (await db.execute(prog_stmt)).scalar_one_or_none()

    if not progress:
        progress = RoadmapStepProgress(
            user_id=current_user.id,
            roadmap_step_id=step_id,
            status=body.status,
        )
        db.add(progress)
    else:
        progress.status = body.status

    if body.notes is not None:
        progress.notes = body.notes
    if body.status == "completed":
        progress.completed_at = datetime.now(timezone.utc)

    await db.flush()

    # Calculate roadmap completion
    all_steps_stmt = select(func.count()).where(RoadmapStep.roadmap_id == roadmap_id)
    total = (await db.execute(all_steps_stmt)).scalar() or 0

    completed_stmt = select(func.count()).where(
        RoadmapStepProgress.roadmap_step_id.in_(
            select(RoadmapStep.id).where(RoadmapStep.roadmap_id == roadmap_id)
        ),
        RoadmapStepProgress.user_id == current_user.id,
        RoadmapStepProgress.status == "completed",
    )
    completed = (await db.execute(completed_stmt)).scalar() or 0

    return {
        "success": True,
        "data": {
            "step_id": str(step_id),
            "status": progress.status,
            "completed_at": progress.completed_at,
            "roadmap_completion_percent": int((completed / max(total, 1)) * 100),
        },
    }
