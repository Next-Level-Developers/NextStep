"""
Profiler request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List


# ── Question Bank ──────────────────────────────────────────────

class QuestionOption(BaseModel):
    index: int
    text: str
    emoji: Optional[str] = None
    dimension_weights: dict = {}


class ProfilerQuestion(BaseModel):
    code: str
    section: str
    section_label: str
    question_text: str
    instruction: Optional[str] = None
    question_type: str
    max_selections: Optional[int] = None
    is_scored: bool
    is_skippable: Optional[bool] = False
    options: List[QuestionOption]


# ── Sessions ───────────────────────────────────────────────────

class ProfilerSessionOut(BaseModel):
    session_id: UUID
    session_number: int
    status: str
    total_questions: int
    questions_answered: int
    questions_skipped: int = 0
    last_answered_code: Optional[str] = None
    started_at: datetime

    model_config = {"from_attributes": True}


# ── Responses ──────────────────────────────────────────────────

class ProfilerResponseItem(BaseModel):
    question_code: str
    question_section: str
    selected_option_index: List[int]
    skipped: bool = False


class ProfilerResponsesRequest(BaseModel):
    responses: List[ProfilerResponseItem]


class ProfilerResponsesResult(BaseModel):
    session_id: UUID
    questions_answered: int
    questions_skipped: int
    progress_percent: int


# ── Interest Profile ──────────────────────────────────────────

class InterestProfileOut(BaseModel):
    id: UUID
    session_id: UUID
    is_active: bool
    dimension_scores: dict
    top_dimensions: List[str]
    career_cluster_weights: dict = {}
    awareness_known_careers: Optional[List[str]] = None
    computed_at: datetime

    model_config = {"from_attributes": True}


# ── Session Complete ──────────────────────────────────────────

class SessionCompleteResult(BaseModel):
    session_id: UUID
    status: str
    time_taken_seconds: Optional[int] = None
    interest_profile: InterestProfileOut
    recommendations_ready: bool = False
    recommendations_eta_seconds: int = 3
