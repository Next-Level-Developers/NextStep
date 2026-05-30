"""
Notifications router.

GET   /api/v1/notifications/
PATCH /api/v1/notifications/{notification_id}/read/
POST  /api/v1/notifications/mark-all-read/
"""

from uuid import UUID
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select, update, func
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.dependencies import get_current_user
from models.user import User
from models.notification import Notification


router = APIRouter()


@router.get("/")
async def list_notifications(
    is_read: bool | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """All in-app notifications."""
    query = select(Notification).where(Notification.user_id == current_user.id)
    if is_read is not None:
        query = query.where(Notification.is_read == is_read)
    query = query.order_by(Notification.sent_at.desc())

    result = await db.execute(query)
    notifications = result.scalars().all()

    unread_stmt = select(func.count()).where(
        Notification.user_id == current_user.id, Notification.is_read == False
    )
    unread_count = (await db.execute(unread_stmt)).scalar() or 0

    return {
        "success": True,
        "data": {
            "unread_count": unread_count,
            "results": [
                {
                    "id": str(n.id),
                    "type": n.type,
                    "title": n.title,
                    "body": n.body,
                    "is_read": n.is_read,
                    "sent_at": n.sent_at,
                    "read_at": n.read_at,
                }
                for n in notifications
            ],
        },
    }


@router.patch("/{notification_id}/read/")
async def mark_notification_read(
    notification_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Mark notification as read."""
    notif = await db.get(Notification, notification_id)
    if not notif or notif.user_id != current_user.id:
        return {"success": False, "error": {"code": "NOT_FOUND", "message": "Notification not found."}}

    now = datetime.now(timezone.utc)
    notif.is_read = True
    notif.read_at = now
    await db.flush()

    return {
        "success": True,
        "data": {"id": str(notif.id), "is_read": True, "read_at": now},
    }


@router.post("/mark-all-read/")
async def mark_all_read(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Mark all notifications read."""
    now = datetime.now(timezone.utc)
    stmt = (
        update(Notification)
        .where(Notification.user_id == current_user.id, Notification.is_read == False)
        .values(is_read=True, read_at=now)
    )
    result = await db.execute(stmt)

    return {
        "success": True,
        "data": {"marked_read_count": result.rowcount},
    }
