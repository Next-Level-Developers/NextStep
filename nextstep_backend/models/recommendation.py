"""
CareerRecommendation, CareerView, CareerSave models.

Ported from apps/recommendations/models.py (Django ORM → SQLAlchemy 2.0 async).
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


class CareerRecommendation(Base):
    __tablename__ = "career_recommendations"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    interest_profile_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("interest_profiles.id", ondelete="CASCADE")
    )
    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("careers.id", ondelete="CASCADE")
    )
    match_score: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    match_tier: Mapped[str] = mapped_column(String(20), nullable=False)
    tag_overlap_count: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    display_rank: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    is_novel: Mapped[bool] = mapped_column(Boolean, default=False)
    generated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )

    # Relationships
    career: Mapped["Career"] = relationship()

    __table_args__ = (
        Index("career_recs_user_idx", "user_id"),
        Index("career_recs_ip_idx", "interest_profile_id"),
    )

    def __repr__(self) -> str:
        return f"CareerRecommendation(user={self.user_id}, career={self.career_id})"


# Avoid circular import — import at module level for type hints
from models.career import Career


class CareerView(Base):
    __tablename__ = "career_views"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("careers.id", ondelete="CASCADE")
    )
    source: Mapped[str] = mapped_column(String(30), default="")
    viewed_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )
    time_spent_seconds: Mapped[int | None] = mapped_column(Integer, nullable=True)
    reached_roadmap: Mapped[bool] = mapped_column(Boolean, default=False)

    __table_args__ = (
        Index("career_views_user_idx", "user_id"),
        Index("career_views_career_idx", "career_id"),
    )

    def __repr__(self) -> str:
        return f"CareerView(user={self.user_id}, career={self.career_id})"


class CareerSave(Base):
    __tablename__ = "career_saves"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("careers.id", ondelete="CASCADE")
    )
    saved_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    career: Mapped["Career"] = relationship()

    __table_args__ = (
        UniqueConstraint("user_id", "career_id", name="unique_career_save"),
    )

    def __repr__(self) -> str:
        return f"CareerSave(user={self.user_id}, career={self.career_id})"
