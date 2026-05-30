"""
Content router — stories and resources for careers.

GET /api/v1/content/careers/{slug}/stories/
GET /api/v1/content/careers/{slug}/resources/
"""

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.dependencies import get_current_user
from core.exceptions import NexStepException
from models.user import User
from models.career import Career
from models.content import RealPeopleStory, LearningResource


router = APIRouter()


@router.get("/careers/{slug}/stories/")
async def get_career_stories(
    slug: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Real people stories for a specific career."""
    career = (await db.execute(select(Career).where(Career.slug == slug))).scalar_one_or_none()
    if not career:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Career not found.", http_status=404)

    stmt = (
        select(RealPeopleStory)
        .where(RealPeopleStory.career_id == career.id, RealPeopleStory.is_active == True)
        .order_by(RealPeopleStory.created_at)
    )
    result = await db.execute(stmt)
    stories = result.scalars().all()

    is_premium_user = current_user.subscription_tier != "free"

    data = []
    for s in stories:
        locked = s.is_premium and not is_premium_user
        data.append({
            "id": str(s.id),
            "person_name": s.person_name,
            "person_age": s.person_age,
            "person_city": s.person_city,
            "person_background": s.person_background,
            "story_text": s.story_text if not locked else None,
            "is_premium": s.is_premium,
            "locked": locked,
        })

    return {"success": True, "data": {"career_slug": slug, "stories": data}}


@router.get("/careers/{slug}/resources/")
async def get_career_resources(
    slug: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Curated learning resources for a specific career."""
    career = (await db.execute(select(Career).where(Career.slug == slug))).scalar_one_or_none()
    if not career:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Career not found.", http_status=404)

    stmt = (
        select(LearningResource)
        .where(
            LearningResource.career_ids.any(career.id),
            LearningResource.is_active == True,
        )
        .order_by(LearningResource.created_at)
    )
    result = await db.execute(stmt)
    resources = result.scalars().all()

    data = [
        {
            "id": str(r.id),
            "title": r.title,
            "url": r.url,
            "provider": r.provider,
            "resource_type": r.resource_type,
            "is_free": r.is_free,
        }
        for r in resources
    ]

    return {"success": True, "data": {"career_slug": slug, "resources": data}}
