"""
Users router — profile CRUD, avatar upload, student profile, parental consent.

GET/PATCH/DELETE  /api/v1/users/me/
POST              /api/v1/users/me/avatar/
GET/PUT           /api/v1/users/me/student-profile/
POST              /api/v1/users/me/parental-consent/
POST              /api/v1/users/me/share-token/
"""

import secrets
from datetime import datetime, timedelta, timezone
from uuid import UUID

from fastapi import APIRouter, Depends, UploadFile, File, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from core.database import get_db
from core.dependencies import get_current_user, require_student
from core.s3_service import upload_avatar_to_s3
from models.user import User, StudentProfile
from schemas.user import (
    UserOut, UserUpdate, StudentProfileOut, StudentProfileCreate,
    ParentalConsentRequest, ParentalConsentResponse,
    ShareTokenResponse, AvatarResponse,
)


router = APIRouter()


@router.get("/me/")
async def get_current_user_profile(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get the currently authenticated user's full profile."""
    # Eager load student_profile
    stmt = (
        select(User)
        .options(selectinload(User.student_profile))
        .where(User.id == current_user.id)
    )
    result = await db.execute(stmt)
    user = result.scalar_one()

    user_data = {
        "id": str(user.id),
        "email": user.email,
        "full_name": user.full_name,
        "phone": user.phone,
        "avatar_url": user.avatar_url,
        "user_type": user.user_type,
        "subscription_tier": user.subscription_tier,
        "subscription_expires_at": user.subscription_expires_at,
        "parental_consent_given": user.parental_consent_given,
        "created_at": user.created_at,
        "student_profile": None,
    }

    if user.student_profile:
        sp = user.student_profile
        user_data["student_profile"] = {
            "academic_stage": sp.academic_stage,
            "grade_or_year": sp.grade_or_year,
            "school_name": sp.school_name,
            "city": sp.city,
            "state": sp.state,
            "career_clarity": sp.career_clarity,
            "pressure_level": sp.pressure_level,
            "profiler_completed": sp.profiler_completed,
            "profiler_completed_at": sp.profiler_completed_at,
        }

    return {"success": True, "data": user_data}


@router.patch("/me/")
async def update_user_profile(
    body: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Update the authenticated user's core profile fields."""
    if body.full_name is not None:
        current_user.full_name = body.full_name
    if body.phone is not None:
        current_user.phone = body.phone
    await db.flush()

    return {"success": True, "data": {"id": str(current_user.id), "full_name": current_user.full_name, "phone": current_user.phone}}


@router.delete("/me/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Soft-delete the account."""
    current_user.is_active = False
    await db.flush()
    return None


@router.post("/me/avatar/")
async def upload_avatar(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Upload profile picture to S3."""
    avatar_url = await upload_avatar_to_s3(file, current_user.id)
    current_user.avatar_url = avatar_url
    await db.flush()
    return {"success": True, "data": {"avatar_url": avatar_url}}


@router.get("/me/student-profile/")
async def get_student_profile(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_student),
):
    """Get student profile."""
    stmt = select(StudentProfile).where(StudentProfile.user_id == current_user.id)
    result = await db.execute(stmt)
    profile = result.scalar_one_or_none()

    if not profile:
        return {"success": True, "data": None}

    return {"success": True, "data": StudentProfileOut.model_validate(profile).model_dump()}


@router.put("/me/student-profile/")
async def create_or_update_student_profile(
    body: StudentProfileCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Create or fully update the student profile."""
    stmt = select(StudentProfile).where(StudentProfile.user_id == current_user.id)
    result = await db.execute(stmt)
    profile = result.scalar_one_or_none()

    if profile:
        for field, value in body.model_dump(exclude_unset=True).items():
            setattr(profile, field, value)
    else:
        profile = StudentProfile(
            user_id=current_user.id,
            **body.model_dump(),
        )
        db.add(profile)

    await db.flush()
    return {"success": True, "data": StudentProfileOut.model_validate(profile).model_dump()}


@router.post("/me/parental-consent/")
async def submit_parental_consent(
    body: ParentalConsentRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Submit parental consent."""
    current_user.parental_consent_given = body.consent_given
    if body.consent_given:
        current_user.parental_consent_at = datetime.now(timezone.utc)
    await db.flush()

    return {
        "success": True,
        "data": {
            "parental_consent_given": current_user.parental_consent_given,
            "parental_consent_at": current_user.parental_consent_at,
        },
    }


@router.post("/me/share-token/", status_code=201)
async def generate_share_token(
    current_user: User = Depends(get_current_user),
):
    """Generate a shareable parent-view token."""
    token = f"nxt_share_{secrets.token_urlsafe(16)}"
    expires = datetime.now(timezone.utc) + timedelta(days=30)

    return {
        "success": True,
        "data": {
            "share_token": token,
            "share_url": f"https://app.nextstep.app/parent-view/{token}",
            "expires_at": expires,
        },
    }
