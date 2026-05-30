"""
Notification, CheckInPrompt models.

Ported from apps/notifications/models.py (Django ORM → SQLAlchemy 2.0 async).
"""

import uuid
from datetime import datetime

from sqlalchemy import (
    String, Boolean, DateTime,
    ForeignKey, Text, func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID

from core.database import Base


class Notification(Base):
    __tablename__ = "notifications"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    type: Mapped[str] = mapped_column(String(50), nullable=False)
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    body: Mapped[str] = mapped_column(Text, default="")
    is_read: Mapped[bool] = mapped_column(Boolean, default=False)
    sent_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    read_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    def __repr__(self) -> str:
        return f"Notification(user={self.user_id}, type={self.type})"


class CheckInPrompt(Base):
    __tablename__ = "check_in_prompts"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    career_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True), ForeignKey("careers.id", ondelete="SET NULL"), nullable=True
    )
    prompt_type: Mapped[str] = mapped_column(String(30), nullable=False)
    sent_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    responded_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    response: Mapped[str | None] = mapped_column(String(20), nullable=True)

    # Relationships
    career: Mapped["Career | None"] = relationship()

    def __repr__(self) -> str:
        return f"CheckInPrompt(user={self.user_id}, type={self.prompt_type})"


from models.career import Career
