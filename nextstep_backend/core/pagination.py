"""
Pagination helpers for list endpoints.

Replaces utils/pagination.py (DRF StandardResultsSetPagination).
"""

from typing import Annotated, Any, TypeVar, Generic, List, Optional

from fastapi import Query
from pydantic import BaseModel


PageParam = Annotated[int, Query(ge=1, description="Page number (1-indexed)")]
PageSizeParam = Annotated[int, Query(ge=1, le=50, description="Items per page (max 50)")]


T = TypeVar("T")


class PaginatedData(BaseModel, Generic[T]):
    """Paginated response data shape matching DRF's default."""
    count: int
    next: Optional[str] = None
    previous: Optional[str] = None
    results: List[Any]


def paginate_query_params(page: int = 1, page_size: int = 20) -> tuple[int, int]:
    """Convert page/page_size to offset/limit for SQL queries."""
    offset = (page - 1) * page_size
    return offset, page_size


def build_pagination_urls(
    base_url: str,
    page: int,
    page_size: int,
    total_count: int,
) -> tuple[Optional[str], Optional[str]]:
    """Build next/previous page URLs."""
    total_pages = (total_count + page_size - 1) // page_size

    next_url = None
    if page < total_pages:
        next_url = f"{base_url}?page={page + 1}&page_size={page_size}"

    previous_url = None
    if page > 1:
        previous_url = f"{base_url}?page={page - 1}&page_size={page_size}"

    return next_url, previous_url
