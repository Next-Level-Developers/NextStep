"""
User and StudentProfile request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional
from enum import Enum


class AcademicStage(str, Enum):
    GRADE_8_9 = "grade_8_9"
    GRADE_10 = "grade_10"
    GRADE_11_12_SCIENCE = "grade_11_12_science"
    GRADE_11_12_COMMERCE = "grade_11_12_commerce"
    GRADE_11_12_ARTS = "grade_11_12_arts"
    COLLEGE_YEAR_1_2 = "college_year_1_2"


class CareerClarity(str, Enum):
    CLEAR = "clear"
    FEW_OPTIONS = "few_options"
    NONE = "none"
    WANTS_TO_EXPLORE = "wants_to_explore"


class PressureLevel(str, Enum):
    HIGH = "high"
    SOME = "some"
    LOW = "low"
    VERY_HIGH = "very_high"


class CareerAwarenessLevel(str, Enum):
    NARROW = "narrow"
    MODERATE = "moderate"
    BROAD = "broad"
    FOCUSED = "focused"


# ── Student Profile ────────────────────────────────────────────

class StudentProfileOut(BaseModel):
    id: UUID
    user_id: UUID
    academic_stage: str
    grade_or_year: Optional[str] = None
    school_name: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    career_clarity: Optional[str] = None
    pressure_level: Optional[str] = None
    career_awareness_level: Optional[str] = None
    profiler_completed: bool = False
    profiler_completed_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class StudentProfileCreate(BaseModel):
    academic_stage: AcademicStage
    grade_or_year: Optional[str] = None
    school_name: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    career_clarity: Optional[CareerClarity] = None
    pressure_level: Optional[PressureLevel] = None
    career_awareness_level: Optional[CareerAwarenessLevel] = None


# ── User ───────────────────────────────────────────────────────

class UserOut(BaseModel):
    id: UUID
    email: str
    full_name: Optional[str] = None
    phone: Optional[str] = None
    avatar_url: Optional[str] = None
    user_type: str
    subscription_tier: str
    subscription_expires_at: Optional[datetime] = None
    parental_consent_given: bool = False
    created_at: datetime
    student_profile: Optional[StudentProfileOut] = None

    model_config = {"from_attributes": True}


class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    phone: Optional[str] = None


class ParentalConsentRequest(BaseModel):
    consent_given: bool
    parent_name: Optional[str] = None
    parent_phone: Optional[str] = None


class ParentalConsentResponse(BaseModel):
    parental_consent_given: bool
    parental_consent_at: Optional[datetime] = None


class ShareTokenResponse(BaseModel):
    share_token: str
    share_url: str
    expires_at: datetime


class AvatarResponse(BaseModel):
    avatar_url: str
