"""
Roadmap, RoadmapStep, RoadmapStepProgress models.

Ported from apps/roadmaps/models.py (Django ORM → SQLAlchemy 2.0 async).
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


class Roadmap(Base):
    __tablename__ = "roadmaps"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("careers.id", ondelete="CASCADE")
    )
    interest_profile_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("interest_profiles.id", ondelete="CASCADE")
    )
    academic_stage: Mapped[str] = mapped_column(String(30), nullable=False)
    generation_method: Mapped[str] = mapped_column(String(20), default="template")
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    generated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )
    last_updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now(), onupdate=func.now()
    )

    # Relationships
    steps: Mapped[list["RoadmapStep"]] = relationship(
        back_populates="roadmap", cascade="all, delete-orphan"
    )
    career: Mapped["Career"] = relationship()

    # Note: The Django version has a conditional unique constraint:
    # UniqueConstraint(fields=["user", "career"], condition=Q(is_active=True))
    # SQLAlchemy partial unique indexes need to be added via Alembic migration.

    def __repr__(self) -> str:
        return f"Roadmap(user={self.user_id}, career={self.career_id})"


from models.career import Career


class RoadmapStep(Base):
    __tablename__ = "roadmap_steps"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    roadmap_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("roadmaps.id", ondelete="CASCADE")
    )
    step_order: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    category: Mapped[str] = mapped_column(String(30), nullable=False)
    title: Mapped[str] = mapped_column(String(300), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    timeframe: Mapped[str | None] = mapped_column(String(50), nullable=True)
    resource_url: Mapped[str | None] = mapped_column(Text, nullable=True)
    resource_label: Mapped[str | None] = mapped_column(String(200), nullable=True)
    is_premium: Mapped[bool] = mapped_column(Boolean, default=False)

    # Relationships
    roadmap: Mapped["Roadmap"] = relationship(back_populates="steps")
    progress: Mapped[list["RoadmapStepProgress"]] = relationship(
        back_populates="roadmap_step", cascade="all, delete-orphan"
    )

    __table_args__ = (
        Index("roadmap_steps_roadmap_idx", "roadmap_id"),
    )

    def __repr__(self) -> str:
        return f"RoadmapStep(roadmap={self.roadmap_id}, order={self.step_order})"


class RoadmapStepProgress(Base):
    __tablename__ = "roadmap_step_progress"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    roadmap_step_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("roadmap_steps.id", ondelete="CASCADE")
    )
    status: Mapped[str] = mapped_column(String(20), default="not_started")
    completed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    roadmap_step: Mapped["RoadmapStep"] = relationship(back_populates="progress")

    __table_args__ = (
        UniqueConstraint("user_id", "roadmap_step_id", name="unique_roadmap_step_progress"),
        Index("roadmap_step_progress_user_idx", "user_id"),
    )

    def __repr__(self) -> str:
        return f"RoadmapStepProgress(user={self.user_id}, step={self.roadmap_step_id})"
