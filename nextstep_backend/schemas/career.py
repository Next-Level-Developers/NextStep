"""
Career, CareerDomain, CareerCluster request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from typing import Optional, List
from datetime import date


class CareerDomainBrief(BaseModel):
    id: UUID
    slug: str
    name: str
    short_name: str

    model_config = {"from_attributes": True}


class CareerDomainOut(BaseModel):
    id: UUID
    slug: str
    name: str
    short_name: str
    india_relevance: str = ""
    growth_forecast_2035: str = ""
    entry_path_summary: str = ""
    career_count: int = 0
    display_order: Optional[int] = None

    model_config = {"from_attributes": True}


class CareerClusterOut(BaseModel):
    id: UUID
    name: str
    q24_description: str = ""
    domain_count: int = 0
    career_count: int = 0

    model_config = {"from_attributes": True}


class CareerListItem(BaseModel):
    id: UUID
    slug: str
    name: str
    one_liner: str
    domain: CareerDomainBrief
    dimension_tags: List[str]
    india_viability: str
    future_score: int
    is_emerging: bool = False
    salary_entry_lpa: Optional[str] = None
    salary_mid_lpa: Optional[str] = None
    salary_senior_lpa: Optional[str] = None

    model_config = {"from_attributes": True}


class RelatedCareer(BaseModel):
    slug: str
    name: str
    one_liner: Optional[str] = None
    future_score: int


class CareerDetailOut(BaseModel):
    id: UUID
    slug: str
    name: str
    one_liner: str
    domain: CareerDomainBrief
    dimension_tags: List[str]
    india_viability: str
    future_score: int
    future_score_reasoning: Optional[str] = None
    typical_day: Optional[str] = None
    skills_needed: Optional[List[str]] = None
    entry_paths: Optional[List[str]] = None
    salary_entry_lpa: Optional[str] = None
    salary_mid_lpa: Optional[str] = None
    salary_senior_lpa: Optional[str] = None
    is_emerging: bool = False
    last_reviewed_at: Optional[date] = None
    related_careers: List[RelatedCareer] = []
    is_saved: bool = False
    user_match_score: Optional[int] = None

    model_config = {"from_attributes": True}


class CareerCompareItem(BaseModel):
    slug: str
    name: str
    dimension_tags: List[str]
    future_score: int
    india_viability: str
    salary_entry_lpa: Optional[str] = None
    salary_mid_lpa: Optional[str] = None
    salary_senior_lpa: Optional[str] = None
    user_skill_overlap_count: int = 0
    user_skill_overlap: List[str] = []
    work_style: Optional[str] = None
    time_to_first_job_months: Optional[int] = None
    entry_difficulty: Optional[str] = None


class CareerCompareResult(BaseModel):
    careers: List[CareerCompareItem]
    comparison_dimensions: List[str] = [
        "salary", "future_score", "skill_overlap", "entry_difficulty", "india_viability"
    ]
