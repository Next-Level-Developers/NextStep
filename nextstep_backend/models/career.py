"""
CareerDomain, CareerCluster, Career models.

Ported from apps/careers/models.py (Django ORM → SQLAlchemy 2.0 async).
"""

import uuid
from datetime import datetime, date

from sqlalchemy import (
    String, Boolean, DateTime, Integer, SmallInteger, BigInteger,
    ForeignKey, Index, Text, Date, func,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSONB

from core.database import Base


class CareerDomain(Base):
    __tablename__ = "career_domains"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    slug: Mapped[str] = mapped_column(String(80), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String(150), nullable=False)
    short_name: Mapped[str] = mapped_column(String(60), nullable=False)
    india_relevance: Mapped[str] = mapped_column(String(20), default="")
    growth_forecast_2035: Mapped[str] = mapped_column(String(20), default="")
    entry_path_summary: Mapped[str] = mapped_column(String(300), default="")
    display_order: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    # Relationships
    careers: Mapped[list["Career"]] = relationship(back_populates="domain")

    def __repr__(self) -> str:
        return f"CareerDomain(slug={self.slug})"


class CareerCluster(Base):
    __tablename__ = "career_clusters"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    q24_description: Mapped[str] = mapped_column(Text, default="")
    domain_ids: Mapped[list[uuid.UUID] | None] = mapped_column(
        ARRAY(UUID(as_uuid=True)), nullable=True
    )

    def __repr__(self) -> str:
        return f"CareerCluster(name={self.name})"


class Career(Base):
    __tablename__ = "careers"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    slug: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String(150), nullable=False)
    one_liner: Mapped[str] = mapped_column(String(300), nullable=False)
    domain_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("career_domains.id", ondelete="CASCADE")
    )
    dimension_tags: Mapped[list[str]] = mapped_column(ARRAY(String(2)), nullable=False)
    india_viability: Mapped[str] = mapped_column(String(20), nullable=False)
    future_score: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    future_score_reasoning: Mapped[str | None] = mapped_column(Text, nullable=True)
    typical_day: Mapped[str | None] = mapped_column(Text, nullable=True)
    skills_needed: Mapped[list[str] | None] = mapped_column(ARRAY(Text), nullable=True)
    entry_paths: Mapped[list[str] | None] = mapped_column(ARRAY(Text), nullable=True)
    salary_entry_min_paise: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    salary_entry_max_paise: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    salary_mid_min_paise: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    salary_mid_max_paise: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    salary_senior_min_paise: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    salary_senior_max_paise: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    related_career_ids: Mapped[list[uuid.UUID] | None] = mapped_column(
        ARRAY(UUID(as_uuid=True)), nullable=True
    )
    is_emerging: Mapped[bool] = mapped_column(Boolean, default=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    last_reviewed_at: Mapped[date | None] = mapped_column(Date, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=func.now(), onupdate=func.now()
    )

    # Relationships
    domain: Mapped["CareerDomain"] = relationship(back_populates="careers")

    __table_args__ = (
        Index("careers_slug_idx", "slug"),
        Index("careers_domain_idx", "domain_id"),
        Index("careers_future_score_idx", "future_score"),
        Index("careers_india_viability_idx", "india_viability"),
    )

    def __repr__(self) -> str:
        return f"Career(slug={self.slug})"
