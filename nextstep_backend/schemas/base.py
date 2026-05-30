"""
Base response schemas — generic envelope used by all endpoints.
"""

from pydantic import BaseModel
from typing import Generic, TypeVar, Optional, List, Any

T = TypeVar("T")


class APIResponse(BaseModel, Generic[T]):
    """Standard response envelope: { success, data, message }."""
    success: bool = True
    data: T
    message: Optional[str] = None


class ErrorDetail(BaseModel):
    code: str
    message: str
    details: dict = {}


class ErrorResponse(BaseModel):
    """Standard error envelope: { success: false, error: { code, message, details } }."""
    success: bool = False
    error: ErrorDetail


class PaginatedData(BaseModel, Generic[T]):
    """Paginated list: { count, next, previous, results }."""
    count: int
    next: Optional[str] = None
    previous: Optional[str] = None
    results: List[Any]
