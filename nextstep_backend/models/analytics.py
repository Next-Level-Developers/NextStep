"""
AnalyticsEvent model.

Ported from apps/analytics/models.py (Django ORM → SQLAlchemy 2.0 async).
"""

import uuid
from datetime import datetime

from sqlalchemy import (
    String, DateTime, ForeignKey, Index, func,
)
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.dialects.postgresql import UUID, JSONB

from core.database import Base


class AnalyticsEvent(Base):
    __tablename__ = "analytics_events"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    session_id: Mapped[str | None] = mapped_column(String(100), nullable=True)
    event_name: Mapped[str] = mapped_column(String(100), nullable=False)
    properties: Mapped[dict | None] = mapped_column(JSONB, nullable=True)
    career_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True), ForeignKey("careers.id", ondelete="SET NULL"), nullable=True
    )
    organisation_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True), nullable=True
    )
    occurred_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    __table_args__ = (
        Index("analytics_events_user_idx", "user_id"),
        Index("analytics_events_event_idx", "event_name"),
        Index("analytics_events_occurred_idx", "occurred_at"),
    )

    def __repr__(self) -> str:
        return f"AnalyticsEvent(event={self.event_name})"
