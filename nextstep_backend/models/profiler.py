"""
ProfilerSession, ProfilerResponse, InterestProfile models.

Ported from apps/profiler/models.py (Django ORM → SQLAlchemy 2.0 async).
"""

import uuid
from datetime import datetime

from sqlalchemy import (
    String, Boolean, DateTime, Integer, SmallInteger,
    ForeignKey, Index, Text, func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSONB

from core.database import Base


class ProfilerSession(Base):
    __tablename__ = "profiler_sessions"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    session_number: Mapped[int] = mapped_column(SmallInteger, default=1)
    status: Mapped[str] = mapped_column(String(20), default="in_progress")
    total_questions: Mapped[int] = mapped_column(SmallInteger, default=24)
    questions_answered: Mapped[int] = mapped_column(SmallInteger, default=0)
    questions_skipped: Mapped[int] = mapped_column(SmallInteger, default=0)
    started_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    completed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    time_taken_seconds: Mapped[int | None] = mapped_column(Integer, nullable=True)

    # Relationships
    responses: Mapped[list["ProfilerResponse"]] = relationship(
        back_populates="session", cascade="all, delete-orphan"
    )
    interest_profile: Mapped["InterestProfile | None"] = relationship(
        back_populates="session", uselist=False
    )

    __table_args__ = (
        Index("profiler_sessions_user_idx", "user_id"),
        Index("profiler_sessions_status_idx", "status"),
    )

    def __repr__(self) -> str:
        return f"ProfilerSession(user_id={self.user_id}, session={self.session_number})"


class ProfilerResponse(Base):
    __tablename__ = "profiler_responses"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    session_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("profiler_sessions.id", ondelete="CASCADE")
    )
    question_code: Mapped[str] = mapped_column(String(10), nullable=False)
    question_section: Mapped[str] = mapped_column(String(30), nullable=False)
    selected_option_index: Mapped[list[int]] = mapped_column(
        ARRAY(SmallInteger), default=list
    )
    dimension_weights: Mapped[dict] = mapped_column(JSONB, default=dict)
    skipped: Mapped[bool] = mapped_column(Boolean, default=False)
    answered_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    # Relationships
    session: Mapped["ProfilerSession"] = relationship(back_populates="responses")

    __table_args__ = (
        Index("profiler_responses_session_idx", "session_id"),
    )

    def __repr__(self) -> str:
        return f"ProfilerResponse(session_id={self.session_id}, code={self.question_code})"


class InterestProfile(Base):
    __tablename__ = "interest_profiles"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    session_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("profiler_sessions.id", ondelete="CASCADE"), unique=True
    )
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    dimension_scores: Mapped[dict] = mapped_column(JSONB, nullable=False)
    top_dimensions: Mapped[list[str]] = mapped_column(ARRAY(String(2)), nullable=False)
    career_cluster_weights: Mapped[dict] = mapped_column(JSONB, default=dict)
    awareness_known_careers: Mapped[list[str] | None] = mapped_column(
        ARRAY(String(100)), nullable=True
    )
    computed_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    # Relationships
    session: Mapped["ProfilerSession"] = relationship(back_populates="interest_profile")

    __table_args__ = (
        Index("interest_profiles_user_idx", "user_id"),
        Index("ip_is_active_idx", "is_active"),
    )

    def __repr__(self) -> str:
        return f"InterestProfile(user_id={self.user_id}, active={self.is_active})"
