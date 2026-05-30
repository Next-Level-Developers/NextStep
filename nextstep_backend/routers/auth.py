"""
Auth router — Firebase login, token refresh.

POST /api/v1/auth/firebase/
POST /api/v1/auth/token/refresh/
"""

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.firebase_auth import verify_firebase_token
from core.security import create_access_token, create_refresh_token, decode_refresh_token
from schemas.base import APIResponse
from schemas.auth import (
    FirebaseLoginRequest, AuthTokens, UserBrief,
    TokenRefreshRequest, TokenRefreshResponse,
)
from models.user import User


router = APIRouter()


async def _get_or_create_user(db: AsyncSession, firebase_user: dict) -> tuple[User, bool]:
    """Find existing user by firebase_uid or create a new one."""
    uid = firebase_user.get("uid", "")
    email = firebase_user.get("email", "")
    name = firebase_user.get("name", "") or firebase_user.get("display_name", "")

    stmt = select(User).where(User.firebase_uid == uid)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    if user:
        return user, False

    # Create new user
    user = User(
        firebase_uid=uid,
        email=email,
        full_name=name or None,
        user_type="student",
        subscription_tier="free",
    )
    db.add(user)
    await db.flush()
    return user, True


@router.post("/firebase/", status_code=201)
async def firebase_login(
    body: FirebaseLoginRequest,
    db: AsyncSession = Depends(get_db),
):
    """Exchange Firebase ID token for NextStep JWT pair."""
    firebase_user = await verify_firebase_token(body.firebase_token)
    user, is_new = await _get_or_create_user(db, firebase_user)

    # Check if student profile has been completed
    profiler_completed = False
    if user.student_profile:
        profiler_completed = user.student_profile.profiler_completed

    return {
        "success": True,
        "data": {
            "access": create_access_token(str(user.id)),
            "refresh": create_refresh_token(str(user.id)),
            "is_new_user": is_new,
            "user": {
                "id": str(user.id),
                "email": user.email,
                "user_type": user.user_type,
                "subscription_tier": user.subscription_tier,
                "profiler_completed": profiler_completed,
            },
        },
    }


@router.post("/token/refresh/")
async def refresh_token(body: TokenRefreshRequest):
    """Issue a new access token from a valid refresh token."""
    payload = decode_refresh_token(body.refresh)
    user_id = payload.get("sub")
    new_access = create_access_token(user_id)
    return {
        "success": True,
        "data": {"access": new_access},
    }
