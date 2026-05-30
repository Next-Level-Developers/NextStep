"""
Check-ins router.

GET  /api/v1/check-ins/
POST /api/v1/check-ins/{check_in_id}/respond/
"""

from uuid import UUID
from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from core.database import get_db
from core.dependencies import get_current_user
from core.exceptions import NexStepException
from models.user import User
from models.notification import CheckInPrompt
from schemas.notification import CheckInRespondRequest


router = APIRouter()


@router.get("/")
async def list_check_ins(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Pending check-in prompts."""
    stmt = (
        select(CheckInPrompt)
        .options(selectinload(CheckInPrompt.career))
        .where(
            CheckInPrompt.user_id == current_user.id,
            CheckInPrompt.responded_at.is_(None),
        )
        .order_by(CheckInPrompt.sent_at.desc())
    )
    result = await db.execute(stmt)
    check_ins = result.scalars().all()

    data = []
    for ci in check_ins:
        options = [
            {"value": "still_yes", "label": "Yes, definitely!"},
            {"value": "not_sure", "label": "I'm not sure anymore"},
            {"value": "moved_on", "label": "I've moved on to something else"},
        ]
        data.append({
            "id": str(ci.id),
            "prompt_type": ci.prompt_type,
            "career": {"slug": ci.career.slug, "name": ci.career.name} if ci.career else None,
            "question": f"Still feeling interested in {ci.career.name if ci.career else 'this career'}?",
            "options": options,
            "sent_at": ci.sent_at,
        })

    return {"success": True, "data": data}


@router.post("/{check_in_id}/respond/")
async def respond_to_check_in(
    check_in_id: UUID,
    body: CheckInRespondRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Submit check-in response."""
    ci = await db.get(CheckInPrompt, check_in_id)
    if not ci or ci.user_id != current_user.id:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Check-in not found.", http_status=404)

    now = datetime.now(timezone.utc)
    ci.response = body.response
    ci.responded_at = now
    await db.flush()

    return {
        "success": True,
        "data": {
            "check_in_id": str(ci.id),
            "response": ci.response,
            "responded_at": now,
            "next_action": None,
        },
    }
