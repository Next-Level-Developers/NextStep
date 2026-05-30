"""
RealPeopleStory, LearningResource models.

Ported from apps/content/models.py (Django ORM → SQLAlchemy 2.0 async).
"""

import uuid
from datetime import datetime

from sqlalchemy import (
    String, Boolean, DateTime, SmallInteger,
    ForeignKey, Text, func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, ARRAY

from core.database import Base


class RealPeopleStory(Base):
    __tablename__ = "real_people_stories"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("careers.id", ondelete="CASCADE")
    )
    person_name: Mapped[str] = mapped_column(String(150), nullable=False)
    person_age: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    person_city: Mapped[str | None] = mapped_column(String(100), nullable=True)
    person_background: Mapped[str | None] = mapped_column(String(300), nullable=True)
    story_text: Mapped[str] = mapped_column(Text, nullable=False)
    is_premium: Mapped[bool] = mapped_column(Boolean, default=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )

    def __repr__(self) -> str:
        return f"RealPeopleStory(career={self.career_id}, person={self.person_name})"


class LearningResource(Base):
    __tablename__ = "learning_resources"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    title: Mapped[str] = mapped_column(String(300), nullable=False)
    url: Mapped[str] = mapped_column(Text, nullable=False)
    provider: Mapped[str] = mapped_column(String(150), default="")
    resource_type: Mapped[str] = mapped_column(String(30), default="")
    career_ids: Mapped[list[uuid.UUID] | None] = mapped_column(
        ARRAY(UUID(as_uuid=True)), nullable=True
    )
    skill_tags: Mapped[list[str] | None] = mapped_column(ARRAY(Text), nullable=True)
    is_free: Mapped[bool] = mapped_column(Boolean, default=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )

    def __repr__(self) -> str:
        return f"LearningResource(title={self.title})"
