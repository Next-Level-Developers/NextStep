"""
Analytics router — event logging.

POST /api/v1/analytics/events/
"""

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.dependencies import get_current_user
from models.user import User
from models.analytics import AnalyticsEvent
from schemas.analytics import AnalyticsEventRequest


router = APIRouter()


@router.post("/events/", status_code=201)
async def log_event(
    body: AnalyticsEventRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Log an analytics event. Fire-and-forget."""
    event = AnalyticsEvent(
        user_id=current_user.id,
        session_id=body.session_id,
        event_name=body.event_name,
        career_id=body.career_id,
        properties=body.properties,
    )
    db.add(event)
    await db.flush()

    return {
        "success": True,
        "data": {"event_id": str(event.id)},
    }
