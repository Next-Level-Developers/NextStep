"""
Recommendation request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List


class RecommendedCareerBrief(BaseModel):
    slug: str
    name: str
    one_liner: str
    dimension_tags: List[str]
    domain_short_name: str = ""
    future_score: int
    india_viability: str
    salary_entry_lpa: Optional[str] = None
    is_emerging: bool = False


class RecommendationItem(BaseModel):
    rank: int
    match_score: int
    match_tier: str
    tag_overlap_count: int
    is_novel: bool = False
    career: RecommendedCareerBrief


class RecommendationsResult(BaseModel):
    interest_profile_id: UUID
    generated_at: datetime
    total_matches: int
    recommendations: List[RecommendationItem]


class RegenerateResult(BaseModel):
    status: str = "regenerating"
    eta_seconds: int = 3


# ── Saved Careers ──────────────────────────────────────────────

class SavedCareerBrief(BaseModel):
    slug: str
    name: str
    future_score: int
    domain_short_name: str = ""
    salary_entry_lpa: Optional[str] = None


class SavedCareerItem(BaseModel):
    save_id: UUID
    saved_at: datetime
    notes: Optional[str] = None
    career: SavedCareerBrief


class SavedCareersResult(BaseModel):
    count: int
    results: List[SavedCareerItem]


class CareerSaveRequest(BaseModel):
    notes: Optional[str] = None


class CareerSaveResponse(BaseModel):
    save_id: UUID
    career_slug: str
    saved_at: datetime


class CareerSaveUpdateRequest(BaseModel):
    notes: str


class CareerSaveUpdateResponse(BaseModel):
    save_id: UUID
    notes: str


# ── Career View ────────────────────────────────────────────────

class CareerViewRequest(BaseModel):
    source: str = "recommendation"
    time_spent_seconds: Optional[int] = None
    reached_roadmap: bool = False


class CareerViewResponse(BaseModel):
    view_id: UUID
