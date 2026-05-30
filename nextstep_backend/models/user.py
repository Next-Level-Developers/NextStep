"""
User, StudentProfile, SchoolOrganisation, SchoolMembership models.

Ported from apps/users/models.py (Django ORM → SQLAlchemy 2.0 async).
Table names preserved for RDS compatibility.
"""

import uuid
from datetime import datetime

from sqlalchemy import (
    String, Boolean, DateTime, Integer, SmallInteger,
    ForeignKey, UniqueConstraint, Index, Text, func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID

from core.database import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    firebase_uid: Mapped[str] = mapped_column(String(128), unique=True, nullable=False)
    email: Mapped[str] = mapped_column(String(254), unique=True, nullable=False)
    full_name: Mapped[str | None] = mapped_column(String(200), nullable=True)
    phone: Mapped[str | None] = mapped_column(String(20), nullable=True)
    avatar_url: Mapped[str | None] = mapped_column(Text, nullable=True)
    user_type: Mapped[str] = mapped_column(String(20), nullable=False)
    subscription_tier: Mapped[str] = mapped_column(
        String(20), nullable=False, default="free"
    )
    subscription_expires_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    parental_consent_given: Mapped[bool] = mapped_column(Boolean, default=False)
    parental_consent_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_staff: Mapped[bool] = mapped_column(Boolean, default=False)
    # Django's AbstractBaseUser stores a password hash; we keep the column but won't use it
    password: Mapped[str | None] = mapped_column(String(128), nullable=True)
    last_login: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    is_superuser: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    # Relationships
    student_profile: Mapped["StudentProfile | None"] = relationship(
        back_populates="user", uselist=False
    )
    school_memberships: Mapped[list["SchoolMembership"]] = relationship(
        back_populates="user"
    )

    __table_args__ = (
        Index("users_firebase_uid_idx", "firebase_uid"),
        Index("users_email_idx", "email"),
        Index("users_subscription_tier_idx", "subscription_tier"),
    )

    def __repr__(self) -> str:
        return f"User(id={self.id}, email={self.email})"


class StudentProfile(Base):
    __tablename__ = "student_profiles"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), unique=True
    )
    academic_stage: Mapped[str] = mapped_column(String(30), nullable=False)
    grade_or_year: Mapped[str | None] = mapped_column(String(10), nullable=True)
    school_name: Mapped[str | None] = mapped_column(String(255), nullable=True)
    city: Mapped[str | None] = mapped_column(String(100), nullable=True)
    state: Mapped[str | None] = mapped_column(String(100), nullable=True)
    career_clarity: Mapped[str | None] = mapped_column(String(30), nullable=True)
    pressure_level: Mapped[str | None] = mapped_column(String(20), nullable=True)
    career_awareness_level: Mapped[str | None] = mapped_column(String(20), nullable=True)
    profiler_completed: Mapped[bool] = mapped_column(Boolean, default=False)
    profiler_completed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    # Relationships
    user: Mapped["User"] = relationship(back_populates="student_profile")

    def __repr__(self) -> str:
        return f"StudentProfile(user_id={self.user_id})"


class SchoolOrganisation(Base):
    __tablename__ = "school_organisations"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    type: Mapped[str] = mapped_column(String(30), nullable=False)
    city: Mapped[str] = mapped_column(String(100), default="")
    state: Mapped[str] = mapped_column(String(100), default="")
    contact_email: Mapped[str] = mapped_column(String(254), default="")
    licence_seats: Mapped[int] = mapped_column(Integer, default=0)
    licence_expires_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    # Relationships
    memberships: Mapped[list["SchoolMembership"]] = relationship(
        back_populates="organisation"
    )

    def __repr__(self) -> str:
        return f"SchoolOrganisation(name={self.name})"


class SchoolMembership(Base):
    __tablename__ = "school_memberships"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    organisation_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("school_organisations.id", ondelete="CASCADE")
    )
    role: Mapped[str] = mapped_column(String(20), nullable=False)
    joined_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    # Relationships
    user: Mapped["User"] = relationship(back_populates="school_memberships")
    organisation: Mapped["SchoolOrganisation"] = relationship(
        back_populates="memberships"
    )

    __table_args__ = (
        UniqueConstraint("user_id", "organisation_id", name="unique_school_membership"),
    )

    def __repr__(self) -> str:
        return f"SchoolMembership(user_id={self.user_id}, org_id={self.organisation_id})"
