"""
SubscriptionPlan, SubscriptionTransaction models.

Ported from apps/subscriptions/models.py (Django ORM → SQLAlchemy 2.0 async).
"""

import uuid
from datetime import datetime

from sqlalchemy import (
    String, DateTime, Integer,
    ForeignKey, Text, func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, JSONB

from core.database import Base


class SubscriptionPlan(Base):
    __tablename__ = "subscription_plans"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    name: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    price_paise: Mapped[int] = mapped_column(Integer, nullable=False)
    duration_days: Mapped[int | None] = mapped_column(Integer, nullable=True)
    features: Mapped[dict] = mapped_column(JSONB, nullable=False)

    # Relationships
    transactions: Mapped[list["SubscriptionTransaction"]] = relationship(
        back_populates="plan"
    )

    def __repr__(self) -> str:
        return f"SubscriptionPlan(name={self.name})"


class SubscriptionTransaction(Base):
    __tablename__ = "subscription_transactions"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE")
    )
    plan_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("subscription_plans.id", ondelete="CASCADE")
    )
    razorpay_order_id: Mapped[str | None] = mapped_column(
        String(200), unique=True, nullable=True
    )
    razorpay_payment_id: Mapped[str | None] = mapped_column(String(200), nullable=True)
    amount_paise: Mapped[int] = mapped_column(Integer, nullable=False)
    status: Mapped[str] = mapped_column(String(20), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now(), onupdate=func.now()
    )

    # Relationships
    plan: Mapped["SubscriptionPlan"] = relationship(back_populates="transactions")

    def __repr__(self) -> str:
        return f"SubscriptionTransaction(user={self.user_id}, status={self.status})"
