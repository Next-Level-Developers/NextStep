"""
Auth request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from typing import Optional


class FirebaseLoginRequest(BaseModel):
    firebase_token: str


class UserBrief(BaseModel):
    id: UUID
    email: str
    user_type: str
    subscription_tier: str
    profiler_completed: bool = False

    model_config = {"from_attributes": True}


class AuthTokens(BaseModel):
    access: str
    refresh: str
    is_new_user: bool
    user: UserBrief


class TokenRefreshRequest(BaseModel):
    refresh: str


class TokenRefreshResponse(BaseModel):
    access: str
