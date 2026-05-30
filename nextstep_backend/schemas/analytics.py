"""
Analytics event request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from typing import Optional


class AnalyticsEventRequest(BaseModel):
    event_name: str
    session_id: Optional[str] = None
    career_id: Optional[UUID] = None
    properties: Optional[dict] = None


class AnalyticsEventResponse(BaseModel):
    event_id: UUID
