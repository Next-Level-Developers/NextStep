"""
Counsellor dashboard router.

GET /api/v1/counsellor/dashboard/
GET /api/v1/counsellor/students/
"""

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.dependencies import require_counsellor
from core.exceptions import NexStepException
from models.user import User, StudentProfile, SchoolMembership, SchoolOrganisation
from models.recommendation import CareerRecommendation
from models.career import Career


router = APIRouter()


@router.get("/dashboard/")
async def counsellor_dashboard(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_counsellor),
):
    """Aggregated stats for counsellor's school."""
    # Get counsellor's organisation
    mem_stmt = select(SchoolMembership).where(SchoolMembership.user_id == current_user.id)
    mem = (await db.execute(mem_stmt)).scalar_one_or_none()

    if not mem:
        raise NexStepException(code="PERMISSION_DENIED", message="No school organisation found.", http_status=403)

    org = await db.get(SchoolOrganisation, mem.organisation_id)

    # Count students in the organisation
    student_mems_stmt = select(func.count()).where(
        SchoolMembership.organisation_id == mem.organisation_id,
        SchoolMembership.role == "student",
    )
    students_total = (await db.execute(student_mems_stmt)).scalar() or 0

    return {
        "success": True,
        "data": {
            "organisation": {
                "id": str(org.id) if org else "",
                "name": org.name if org else "",
                "type": org.type if org else "",
                "licence_seats": org.licence_seats if org else 0,
            },
            "students_total": students_total,
            "students_profiler_completed": 0,
            "profiler_completion_rate_percent": 0,
            "top_career_interests": [],
            "top_domains": [],
            "dimension_distribution": {},
        },
    }


@router.get("/students/")
async def list_students(
    profiler_completed: bool | None = None,
    academic_stage: str | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_counsellor),
):
    """Anonymised student list for the counsellor's organisation."""
    mem_stmt = select(SchoolMembership).where(SchoolMembership.user_id == current_user.id)
    mem = (await db.execute(mem_stmt)).scalar_one_or_none()

    if not mem:
        raise NexStepException(code="PERMISSION_DENIED", message="No school organisation found.", http_status=403)

    # Get student user IDs in this org
    student_ids_stmt = (
        select(SchoolMembership.user_id)
        .where(
            SchoolMembership.organisation_id == mem.organisation_id,
            SchoolMembership.role == "student",
        )
    )
    student_ids_result = await db.execute(student_ids_stmt)
    student_ids = [row[0] for row in student_ids_result.fetchall()]

    if not student_ids:
        return {"success": True, "data": {"count": 0, "results": []}}

    # Get student profiles
    query = select(StudentProfile).where(StudentProfile.user_id.in_(student_ids))
    if profiler_completed is not None:
        query = query.where(StudentProfile.profiler_completed == profiler_completed)
    if academic_stage:
        query = query.where(StudentProfile.academic_stage == academic_stage)

    result = await db.execute(query)
    profiles = result.scalars().all()

    results = []
    for idx, sp in enumerate(profiles, 1):
        results.append({
            "student_id": str(sp.user_id),
            "display_name": f"Student #{idx}",
            "academic_stage": sp.academic_stage,
            "profiler_completed": sp.profiler_completed,
            "top_matched_careers": [],
            "roadmaps_active": 0,
            "last_active_at": None,
        })

    return {"success": True, "data": {"count": len(results), "results": results}}
