"""
AI conversation request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List


class AICareerBrief(BaseModel):
    slug: str
    name: str


class AIMessageOut(BaseModel):
    id: UUID
    role: str
    content: str
    tokens_used: Optional[int] = None
    model_version: Optional[str] = None
    created_at: datetime

    model_config = {"from_attributes": True}


class ConversationListItem(BaseModel):
    id: UUID
    conversation_type: str
    career: Optional[AICareerBrief] = None
    title: Optional[str] = None
    message_count: int
    last_message_at: Optional[datetime] = None
    is_active: bool

    model_config = {"from_attributes": True}


class ConversationDetailOut(BaseModel):
    conversation_id: UUID
    conversation_type: str
    career: Optional[AICareerBrief] = None
    title: Optional[str] = None
    message_count: int
    started_at: datetime
    last_message_at: Optional[datetime] = None
    messages: List[AIMessageOut] = []


class StartConversationRequest(BaseModel):
    conversation_type: str  # "general" | "career_specific"
    career_slug: Optional[str] = None
    first_message: str


class SendMessageRequest(BaseModel):
    content: str


class SendMessageResponse(BaseModel):
    user_message: AIMessageOut
    assistant_message: AIMessageOut
