"""
Roadmap request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List


class RoadmapCareerBrief(BaseModel):
    slug: str
    name: str
    domain_short_name: str = ""


class RoadmapStepOut(BaseModel):
    id: UUID
    step_order: int
    category: str
    title: str
    description: Optional[str] = None
    timeframe: Optional[str] = None
    resource_url: Optional[str] = None
    resource_label: Optional[str] = None
    is_premium: bool = False
    status: str = "not_started"
    completed_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class RoadmapListItem(BaseModel):
    id: UUID
    career: RoadmapCareerBrief
    academic_stage: str
    generation_method: str
    is_active: bool
    total_steps: int = 0
    completed_steps: int = 0
    completion_percent: int = 0
    generated_at: datetime


class RoadmapDetailOut(BaseModel):
    id: UUID
    career: RoadmapCareerBrief
    academic_stage: str
    generation_method: str
    is_active: bool
    generated_at: datetime
    steps: List[RoadmapStepOut] = []


class RoadmapCreateRequest(BaseModel):
    career_slug: str


class StepProgressUpdateRequest(BaseModel):
    status: str  # not_started | in_progress | completed
    notes: Optional[str] = None


class StepProgressUpdateResponse(BaseModel):
    step_id: UUID
    status: str
    completed_at: Optional[datetime] = None
    roadmap_completion_percent: int


# ── Progress Summary ──────────────────────────────────────────

class NextStepBrief(BaseModel):
    id: UUID
    title: str
    category: str
    timeframe: Optional[str] = None


class RoadmapProgressItem(BaseModel):
    id: UUID
    career_name: str
    total_steps: int
    completed_steps: int
    completion_percent: int
    next_step: Optional[NextStepBrief] = None


class InterestProfileSummary(BaseModel):
    top_dimensions: List[str]
    dimension_scores: dict


class ProgressSummaryResult(BaseModel):
    active_roadmaps: int
    total_steps_across_all: int
    completed_steps: int
    overall_completion_percent: int
    roadmaps: List[RoadmapProgressItem]
    interest_profile_summary: Optional[InterestProfileSummary] = None
    top_3_matched_careers: List[str] = []
