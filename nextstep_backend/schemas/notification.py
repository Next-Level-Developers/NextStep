"""
Notification and CheckIn request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List


# ── Notifications ──────────────────────────────────────────────

class NotificationOut(BaseModel):
    id: UUID
    type: str
    title: str
    body: str = ""
    is_read: bool = False
    sent_at: datetime
    read_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class NotificationsResult(BaseModel):
    unread_count: int
    results: List[NotificationOut]


class NotificationReadResponse(BaseModel):
    id: UUID
    is_read: bool = True
    read_at: datetime


class MarkAllReadResponse(BaseModel):
    marked_read_count: int


# ── Check-Ins ──────────────────────────────────────────────────

class CheckInOption(BaseModel):
    value: str
    label: str


class CheckInCareerBrief(BaseModel):
    slug: str
    name: str


class CheckInPromptOut(BaseModel):
    id: UUID
    prompt_type: str
    career: Optional[CheckInCareerBrief] = None
    question: str = ""
    options: List[CheckInOption] = []
    sent_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class CheckInRespondRequest(BaseModel):
    response: str  # still_yes | not_sure | moved_on


class CheckInRespondResponse(BaseModel):
    check_in_id: UUID
    response: str
    responded_at: datetime
    next_action: Optional[str] = None
