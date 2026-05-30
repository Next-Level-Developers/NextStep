"""
FastAPI Depends() functions for authentication and authorization.

Replaces DRF authentication_classes and permission_classes.
"""

from uuid import UUID

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.security import decode_access_token
from models.user import User


bearer_scheme = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    """Validates Bearer JWT and returns the authenticated User row."""
    token = credentials.credentials
    payload = decode_access_token(token)
    user_id_str: str | None = payload.get("sub")
    if not user_id_str:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token payload",
        )
    user_id = UUID(user_id_str)
    user = await db.get(User, user_id)
    if not user or not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
        )
    return user


async def require_student(
    current_user: User = Depends(get_current_user),
) -> User:
    """Dependency that ensures the current user is a student."""
    if current_user.user_type != "student":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Students only",
        )
    return current_user


async def require_counsellor(
    current_user: User = Depends(get_current_user),
) -> User:
    """Dependency that ensures the current user is a counsellor."""
    if current_user.user_type != "counsellor":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Counsellors only",
        )
    return current_user


async def require_premium(
    current_user: User = Depends(get_current_user),
) -> User:
    """Dependency that ensures the current user has a premium subscription."""
    if current_user.subscription_tier == "free":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="SUBSCRIPTION_REQUIRED",
        )
    return current_user
