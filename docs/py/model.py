"""
models.py — SQLAlchemy ORM models for NextStep
Covers all 10 schema groups from the NextStep Database Schema.
"""

import uuid
from datetime import datetime, date
from typing import Optional

from sqlalchemy import (
    BigInteger, Boolean, CheckConstraint, Column, Date,
    ForeignKey, Integer, SmallInteger, String, Text,
    TIMESTAMP, UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import ARRAY, JSONB, UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.database import Base


# ── Helpers ───────────────────────────────────────────────────────────────────

def gen_uuid():
    return uuid.uuid4()


# ═════════════════════════════════════════════════════════════════════════════
# 1. USERS & AUTH
# ═════════════════════════════════════════════════════════════════════════════

class User(Base):
    __tablename__ = "users"

    id                      = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    firebase_uid            = Column(String(128), unique=True, nullable=False, index=True)
    email                   = Column(String(255), unique=True, nullable=False, index=True)
    full_name               = Column(String(200), nullable=True)
    phone                   = Column(String(20), nullable=True)
    avatar_url              = Column(Text, nullable=True)
    user_type               = Column(String(20), nullable=False)           # student | parent | counsellor | school_admin
    subscription_tier       = Column(String(20), nullable=False, default="free", index=True)
    subscription_expires_at = Column(TIMESTAMP(timezone=True), nullable=True)
    parental_consent_given  = Column(Boolean, default=False)
    parental_consent_at     = Column(TIMESTAMP(timezone=True), nullable=True)
    is_active               = Column(Boolean, default=True)
    created_at              = Column(TIMESTAMP(timezone=True), server_default=func.now())
    updated_at              = Column(TIMESTAMP(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    student_profile         = relationship("StudentProfile", back_populates="user", uselist=False)
    school_memberships      = relationship("SchoolMembership", back_populates="user")
    profiler_sessions       = relationship("ProfilerSession", back_populates="user")
    interest_profiles       = relationship("InterestProfile", back_populates="user")
    career_saves            = relationship("CareerSave", back_populates="user")
    roadmaps                = relationship("Roadmap", back_populates="user")
    ai_conversations        = relationship("AIConversation", back_populates="user")
    analytics_events        = relationship("AnalyticsEvent", back_populates="user")


class StudentProfile(Base):
    __tablename__ = "student_profiles"

    id                      = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id                 = Column(UUID(as_uuid=True), ForeignKey("users.id"), unique=True)
    academic_stage          = Column(String(30), nullable=False)
    grade_or_year           = Column(String(10), nullable=True)
    school_name             = Column(String(255), nullable=True)
    city                    = Column(String(100), nullable=True)
    state                   = Column(String(100), nullable=True)
    career_clarity          = Column(String(30), nullable=True)
    pressure_level          = Column(String(20), nullable=True)
    career_awareness_level  = Column(String(20), nullable=True)
    profiler_completed      = Column(Boolean, default=False)
    profiler_completed_at   = Column(TIMESTAMP(timezone=True), nullable=True)
    created_at              = Column(TIMESTAMP(timezone=True), server_default=func.now())
    updated_at              = Column(TIMESTAMP(timezone=True), server_default=func.now(), onupdate=func.now())

    user = relationship("User", back_populates="student_profile")


class SchoolOrganisation(Base):
    __tablename__ = "school_organisations"

    id                  = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    name                = Column(String(255), nullable=False)
    type                = Column(String(30), nullable=False)   # school | coaching_institute | college
    city                = Column(String(100), nullable=True)
    state               = Column(String(100), nullable=True)
    contact_email       = Column(String(255), nullable=True)
    licence_seats       = Column(Integer, default=0)
    licence_expires_at  = Column(TIMESTAMP(timezone=True), nullable=True)
    is_active           = Column(Boolean, default=True)
    created_at          = Column(TIMESTAMP(timezone=True), server_default=func.now())

    memberships = relationship("SchoolMembership", back_populates="organisation")


class SchoolMembership(Base):
    __tablename__ = "school_memberships"
    __table_args__ = (UniqueConstraint("user_id", "organisation_id"),)

    id              = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id         = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    organisation_id = Column(UUID(as_uuid=True), ForeignKey("school_organisations.id"))
    role            = Column(String(20), nullable=False)   # student | counsellor | admin
    joined_at       = Column(TIMESTAMP(timezone=True), server_default=func.now())

    user         = relationship("User", back_populates="school_memberships")
    organisation = relationship("SchoolOrganisation", back_populates="memberships")


# ═════════════════════════════════════════════════════════════════════════════
# 2. ONBOARDING & INTEREST PROFILING
# ═════════════════════════════════════════════════════════════════════════════

class ProfilerSession(Base):
    __tablename__ = "profiler_sessions"

    id                  = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id             = Column(UUID(as_uuid=True), ForeignKey("users.id"), index=True)
    session_number      = Column(SmallInteger, nullable=False, default=1)
    status              = Column(String(20), nullable=False, default="in_progress", index=True)
    total_questions     = Column(SmallInteger, default=24)
    questions_answered  = Column(SmallInteger, default=0)
    questions_skipped   = Column(SmallInteger, default=0)
    started_at          = Column(TIMESTAMP(timezone=True), server_default=func.now())
    completed_at        = Column(TIMESTAMP(timezone=True), nullable=True)
    time_taken_seconds  = Column(Integer, nullable=True)

    user      = relationship("User", back_populates="profiler_sessions")
    responses = relationship("ProfilerResponse", back_populates="session")


class ProfilerResponse(Base):
    __tablename__ = "profiler_responses"

    id                    = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    session_id            = Column(UUID(as_uuid=True), ForeignKey("profiler_sessions.id"), index=True)
    question_code         = Column(String(10), nullable=False)
    question_section      = Column(String(30), nullable=False)
    selected_option_index = Column(ARRAY(SmallInteger), nullable=False)
    dimension_weights     = Column(JSONB, nullable=False)        # {"C": 1, "A": 0.5}
    skipped               = Column(Boolean, default=False)
    answered_at           = Column(TIMESTAMP(timezone=True), server_default=func.now())

    session = relationship("ProfilerSession", back_populates="responses")


class InterestProfile(Base):
    __tablename__ = "interest_profiles"

    id                       = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id                  = Column(UUID(as_uuid=True), ForeignKey("users.id"), index=True)
    session_id               = Column(UUID(as_uuid=True), ForeignKey("profiler_sessions.id"), unique=True)
    is_active                = Column(Boolean, default=True, index=True)
    dimension_scores         = Column(JSONB, nullable=False)    # {"C": 82, "A": 74, ...}
    top_dimensions           = Column(ARRAY(String(2)), nullable=False)
    career_cluster_weights   = Column(JSONB, nullable=False)
    awareness_known_careers  = Column(ARRAY(String(100)), nullable=True)
    computed_at              = Column(TIMESTAMP(timezone=True), server_default=func.now())

    user                  = relationship("User", back_populates="interest_profiles")
    career_recommendations = relationship("CareerRecommendation", back_populates="interest_profile")


# ═════════════════════════════════════════════════════════════════════════════
# 3. CAREER UNIVERSE
# ═════════════════════════════════════════════════════════════════════════════

class CareerDomain(Base):
    __tablename__ = "career_domains"

    id                    = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    slug                  = Column(String(80), unique=True, nullable=False)
    name                  = Column(String(150), nullable=False)
    short_name            = Column(String(60), nullable=False)
    india_relevance       = Column(String(20), nullable=True)   # very_high | high | medium
    growth_forecast_2035  = Column(String(20), nullable=True)   # very_strong | strong | moderate
    entry_path_summary    = Column(String(300), nullable=True)
    display_order         = Column(SmallInteger, nullable=True)
    is_active             = Column(Boolean, default=True)

    careers = relationship("Career", back_populates="domain")


class Career(Base):
    __tablename__ = "careers"

    id                      = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    slug                    = Column(String(100), unique=True, nullable=False, index=True)
    name                    = Column(String(150), nullable=False)
    one_liner               = Column(String(300), nullable=False)
    domain_id               = Column(UUID(as_uuid=True), ForeignKey("career_domains.id"), index=True)
    dimension_tags          = Column(ARRAY(String(2)), nullable=False)   # ["C", "A", "T"] — GIN indexed
    india_viability         = Column(String(20), nullable=False, index=True)
    future_score            = Column(SmallInteger, nullable=True)
    future_score_reasoning  = Column(Text, nullable=True)
    typical_day             = Column(Text, nullable=True)
    skills_needed           = Column(ARRAY(Text), nullable=True)
    entry_paths             = Column(ARRAY(Text), nullable=True)
    salary_entry_min_paise  = Column(BigInteger, nullable=True)
    salary_entry_max_paise  = Column(BigInteger, nullable=True)
    salary_mid_min_paise    = Column(BigInteger, nullable=True)
    salary_mid_max_paise    = Column(BigInteger, nullable=True)
    salary_senior_min_paise = Column(BigInteger, nullable=True)
    salary_senior_max_paise = Column(BigInteger, nullable=True)
    related_career_ids      = Column(ARRAY(UUID(as_uuid=True)), nullable=True)
    is_emerging             = Column(Boolean, default=False)
    is_active               = Column(Boolean, default=True)
    last_reviewed_at        = Column(Date, nullable=True)
    created_at              = Column(TIMESTAMP(timezone=True), server_default=func.now())
    updated_at              = Column(TIMESTAMP(timezone=True), server_default=func.now(), onupdate=func.now())

    domain               = relationship("CareerDomain", back_populates="careers")
    recommendations      = relationship("CareerRecommendation", back_populates="career")
    views                = relationship("CareerView", back_populates="career")
    saves                = relationship("CareerSave", back_populates="career")
    real_people_stories  = relationship("RealPersonStory", back_populates="career")
    ai_conversations     = relationship("AIConversation", back_populates="career")

    __table_args__ = (
        CheckConstraint("future_score BETWEEN 1 AND 10", name="chk_future_score"),
    )


class CareerCluster(Base):
    """8 high-level clusters shown to students in Q24."""
    __tablename__ = "career_clusters"

    id              = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    name            = Column(String(100), nullable=False)
    q24_description = Column(Text, nullable=True)
    domain_ids      = Column(ARRAY(UUID(as_uuid=True)), nullable=True)


# ═════════════════════════════════════════════════════════════════════════════
# 4. CAREER MATCHING & RECOMMENDATIONS
# ═════════════════════════════════════════════════════════════════════════════

class CareerRecommendation(Base):
    __tablename__ = "career_recommendations"

    id                  = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id             = Column(UUID(as_uuid=True), ForeignKey("users.id"), index=True)
    interest_profile_id = Column(UUID(as_uuid=True), ForeignKey("interest_profiles.id"), index=True)
    career_id           = Column(UUID(as_uuid=True), ForeignKey("careers.id"))
    match_score         = Column(SmallInteger, nullable=False)
    match_tier          = Column(String(20), nullable=False)     # full_match | partial_match | discovery_match
    tag_overlap_count   = Column(SmallInteger, nullable=False)
    display_rank        = Column(SmallInteger, nullable=False)
    is_novel            = Column(Boolean, default=False)
    generated_at        = Column(TIMESTAMP(timezone=True), server_default=func.now())

    interest_profile = relationship("InterestProfile", back_populates="career_recommendations")
    career           = relationship("Career", back_populates="recommendations")

    __table_args__ = (
        CheckConstraint("match_score BETWEEN 0 AND 100", name="chk_match_score"),
    )


class CareerView(Base):
    __tablename__ = "career_views"

    id                   = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id              = Column(UUID(as_uuid=True), ForeignKey("users.id"), index=True)
    career_id            = Column(UUID(as_uuid=True), ForeignKey("careers.id"), index=True)
    source               = Column(String(30), nullable=True)   # recommendation | search | related | ai_suggestion
    viewed_at            = Column(TIMESTAMP(timezone=True), server_default=func.now())
    time_spent_seconds   = Column(Integer, nullable=True)
    reached_roadmap      = Column(Boolean, default=False)

    user   = relationship("User")
    career = relationship("Career", back_populates="views")


class CareerSave(Base):
    __tablename__ = "career_saves"
    __table_args__ = (UniqueConstraint("user_id", "career_id"),)

    id        = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id   = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    career_id = Column(UUID(as_uuid=True), ForeignKey("careers.id"))
    saved_at  = Column(TIMESTAMP(timezone=True), server_default=func.now())
    notes     = Column(Text, nullable=True)

    user   = relationship("User", back_populates="career_saves")
    career = relationship("Career", back_populates="saves")


# ═════════════════════════════════════════════════════════════════════════════
# 5. ROADMAPS & PROGRESS
# ═════════════════════════════════════════════════════════════════════════════

class Roadmap(Base):
    __tablename__ = "roadmaps"

    id                  = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id             = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    career_id           = Column(UUID(as_uuid=True), ForeignKey("careers.id"))
    interest_profile_id = Column(UUID(as_uuid=True), ForeignKey("interest_profiles.id"))
    academic_stage      = Column(String(30), nullable=False)
    generation_method   = Column(String(20), default="template")   # template | ai_generated
    is_active           = Column(Boolean, default=True)
    generated_at        = Column(TIMESTAMP(timezone=True), server_default=func.now())
    last_updated_at     = Column(TIMESTAMP(timezone=True), server_default=func.now(), onupdate=func.now())

    user   = relationship("User", back_populates="roadmaps")
    steps  = relationship("RoadmapStep", back_populates="roadmap")


class RoadmapStep(Base):
    __tablename__ = "roadmap_steps"

    id             = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    roadmap_id     = Column(UUID(as_uuid=True), ForeignKey("roadmaps.id"), index=True)
    step_order     = Column(SmallInteger, nullable=False)
    category       = Column(String(30), nullable=False)   # subject_focus | skill_to_learn | project_to_build | ...
    title          = Column(String(300), nullable=False)
    description    = Column(Text, nullable=True)
    timeframe      = Column(String(50), nullable=True)
    resource_url   = Column(Text, nullable=True)
    resource_label = Column(String(200), nullable=True)
    is_premium     = Column(Boolean, default=False)

    roadmap   = relationship("Roadmap", back_populates="steps")
    progress  = relationship("RoadmapStepProgress", back_populates="step")


class RoadmapStepProgress(Base):
    __tablename__ = "roadmap_step_progress"
    __table_args__ = (UniqueConstraint("user_id", "roadmap_step_id"),)

    id              = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id         = Column(UUID(as_uuid=True), ForeignKey("users.id"), index=True)
    roadmap_step_id = Column(UUID(as_uuid=True), ForeignKey("roadmap_steps.id"))
    status          = Column(String(20), nullable=False, default="not_started")
    completed_at    = Column(TIMESTAMP(timezone=True), nullable=True)
    notes           = Column(Text, nullable=True)

    step = relationship("RoadmapStep", back_populates="progress")


# ═════════════════════════════════════════════════════════════════════════════
# 6. AI CONVERSATIONS
# ═════════════════════════════════════════════════════════════════════════════

class AIConversation(Base):
    __tablename__ = "ai_conversations"

    id                  = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id             = Column(UUID(as_uuid=True), ForeignKey("users.id"), index=True)
    conversation_type   = Column(String(20), nullable=False, index=True)   # general | career_specific
    career_id           = Column(UUID(as_uuid=True), ForeignKey("careers.id"), nullable=True)
    title               = Column(String(300), nullable=True)
    is_active           = Column(Boolean, default=True)
    started_at          = Column(TIMESTAMP(timezone=True), server_default=func.now())
    last_message_at     = Column(TIMESTAMP(timezone=True), nullable=True)
    message_count       = Column(Integer, default=0)

    user     = relationship("User", back_populates="ai_conversations")
    career   = relationship("Career", back_populates="ai_conversations")
    messages = relationship("AIMessage", back_populates="conversation")


class AIMessage(Base):
    __tablename__ = "ai_messages"

    id              = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    conversation_id = Column(UUID(as_uuid=True), ForeignKey("ai_conversations.id"), index=True)
    role            = Column(String(10), nullable=False)   # user | assistant
    content         = Column(Text, nullable=False)
    tokens_used     = Column(Integer, nullable=True)
    model_version   = Column(String(50), nullable=True)
    created_at      = Column(TIMESTAMP(timezone=True), server_default=func.now(), index=True)

    conversation = relationship("AIConversation", back_populates="messages")


# ═════════════════════════════════════════════════════════════════════════════
# 7. CONTENT
# ═════════════════════════════════════════════════════════════════════════════

class RealPersonStory(Base):
    __tablename__ = "real_people_stories"

    id                  = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    career_id           = Column(UUID(as_uuid=True), ForeignKey("careers.id"))
    person_name         = Column(String(150), nullable=False)
    person_age          = Column(SmallInteger, nullable=True)
    person_city         = Column(String(100), nullable=True)
    person_background   = Column(String(300), nullable=True)
    story_text          = Column(Text, nullable=False)
    is_premium          = Column(Boolean, default=False)
    is_active           = Column(Boolean, default=True)
    created_at          = Column(TIMESTAMP(timezone=True), server_default=func.now())

    career = relationship("Career", back_populates="real_people_stories")


class LearningResource(Base):
    __tablename__ = "learning_resources"

    id            = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    title         = Column(String(300), nullable=False)
    url           = Column(Text, nullable=False)
    provider      = Column(String(150), nullable=True)
    resource_type = Column(String(30), nullable=True)   # course | video | article | internship_platform | certification
    career_ids    = Column(ARRAY(UUID(as_uuid=True)), nullable=True)
    skill_tags    = Column(ARRAY(Text), nullable=True)
    is_free       = Column(Boolean, default=True)
    is_active     = Column(Boolean, default=True)
    created_at    = Column(TIMESTAMP(timezone=True), server_default=func.now())


# ═════════════════════════════════════════════════════════════════════════════
# 8. SUBSCRIPTIONS & ACCESS CONTROL
# ═════════════════════════════════════════════════════════════════════════════

class SubscriptionPlan(Base):
    __tablename__ = "subscription_plans"

    id            = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    name          = Column(String(50), unique=True, nullable=False)
    price_paise   = Column(Integer, nullable=False, default=0)
    duration_days = Column(Integer, nullable=True)
    features      = Column(JSONB, nullable=False)

    transactions = relationship("SubscriptionTransaction", back_populates="plan")


class SubscriptionTransaction(Base):
    __tablename__ = "subscription_transactions"

    id                   = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id              = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    plan_id              = Column(UUID(as_uuid=True), ForeignKey("subscription_plans.id"))
    razorpay_order_id    = Column(String(200), unique=True, nullable=True)
    razorpay_payment_id  = Column(String(200), nullable=True)
    amount_paise         = Column(Integer, nullable=False)
    status               = Column(String(20), nullable=False)   # pending | success | failed | refunded
    created_at           = Column(TIMESTAMP(timezone=True), server_default=func.now())
    updated_at           = Column(TIMESTAMP(timezone=True), server_default=func.now(), onupdate=func.now())

    plan = relationship("SubscriptionPlan", back_populates="transactions")


# ═════════════════════════════════════════════════════════════════════════════
# 9. NOTIFICATIONS & CHECK-INS
# ═════════════════════════════════════════════════════════════════════════════

class CheckInPrompt(Base):
    __tablename__ = "check_in_prompts"

    id           = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id      = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    career_id    = Column(UUID(as_uuid=True), ForeignKey("careers.id"), nullable=True)
    prompt_type  = Column(String(30), nullable=False)   # career_still_interested | roadmap_milestone | profile_update
    sent_at      = Column(TIMESTAMP(timezone=True), nullable=True)
    responded_at = Column(TIMESTAMP(timezone=True), nullable=True)
    response     = Column(String(20), nullable=True)    # still_yes | not_sure | moved_on


class Notification(Base):
    __tablename__ = "notifications"

    id      = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    type    = Column(String(50), nullable=False)
    title   = Column(String(200), nullable=False)
    body    = Column(Text, nullable=True)
    is_read = Column(Boolean, default=False)
    sent_at = Column(TIMESTAMP(timezone=True), server_default=func.now())
    read_at = Column(TIMESTAMP(timezone=True), nullable=True)


# ═════════════════════════════════════════════════════════════════════════════
# 10. ANALYTICS & EVENTS
# ═════════════════════════════════════════════════════════════════════════════

class AnalyticsEvent(Base):
    __tablename__ = "analytics_events"

    id              = Column(UUID(as_uuid=True), primary_key=True, default=gen_uuid)
    user_id         = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=True, index=True)
    session_id      = Column(String(100), nullable=True)
    event_name      = Column(String(100), nullable=False, index=True)
    properties      = Column(JSONB, nullable=True)
    career_id       = Column(UUID(as_uuid=True), nullable=True)
    organisation_id = Column(UUID(as_uuid=True), nullable=True)
    occurred_at     = Column(TIMESTAMP(timezone=True), server_default=func.now(), index=True)

    user = relationship("User", back_populates="analytics_events")