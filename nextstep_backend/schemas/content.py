"""
Content (stories and resources) request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from typing import Optional, List


class StoryOut(BaseModel):
    id: UUID
    person_name: str
    person_age: Optional[int] = None
    person_city: Optional[str] = None
    person_background: Optional[str] = None
    story_text: Optional[str] = None
    is_premium: bool = False
    locked: bool = False

    model_config = {"from_attributes": True}


class StoriesResult(BaseModel):
    career_slug: str
    stories: List[StoryOut]


class ResourceOut(BaseModel):
    id: UUID
    title: str
    url: str
    provider: str = ""
    resource_type: str = ""
    is_free: bool = True

    model_config = {"from_attributes": True}


class ResourcesResult(BaseModel):
    career_slug: str
    resources: List[ResourceOut]
