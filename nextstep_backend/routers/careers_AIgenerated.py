"""
routers/careers.py
──────────────────
FastAPI router — Career Universe endpoints for NextStep.

Endpoints:
  GET  /careers/              List with filters & pagination
  GET  /careers/{slug}        Single career detail
  GET  /careers/domain/{slug} All careers in a domain
  GET  /domains/              List all domains
  POST /careers/match/        Match careers to a student's interest profile
"""

from typing import Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db  # your async SQLAlchemy session dependency

router = APIRouter(prefix="/api/v1", tags=["Careers"])


# ──────────────────────────────────────────────────────────────────────────────
# Pydantic response schemas
# ──────────────────────────────────────────────────────────────────────────────

class DomainOut(BaseModel):
    id: UUID
    slug: str
    name: str
    short_name: str
    india_relevance: Optional[str]
    growth_forecast_2035: Optional[str]
    entry_path_summary: Optional[str]
    display_order: Optional[int]

    class Config:
        from_attributes = True


class CareerListItem(BaseModel):
    id: UUID
    slug: str
    name: str
    one_liner: str
    domain_slug: str
    domain_name: str
    dimension_tags: list[str]
    india_viability: str
    future_score: int
    is_emerging: bool

    class Config:
        from_attributes = True


class CareerDetail(CareerListItem):
    typical_day: Optional[str]
    skills_needed: Optional[list[str]]
    entry_paths: Optional[list[str]]
    salary_entry_min_paise: Optional[int]
    salary_entry_max_paise: Optional[int]
    salary_mid_min_paise: Optional[int]
    salary_mid_max_paise: Optional[int]
    salary_senior_min_paise: Optional[int]
    salary_senior_max_paise: Optional[int]
    future_score_reasoning: Optional[str]

    class Config:
        from_attributes = True


class MatchRequest(BaseModel):
    """
    Send the student's top dimension codes (from interest_profiles.top_dimensions).
    Example: {"dimensions": ["C", "A", "T"], "limit": 20}
    """
    dimensions: list[str]
    limit: int = 20
    exclude_emerging: bool = False


class MatchedCareer(CareerListItem):
    tag_overlap_count: int
    match_tier: str   # "full_match" | "partial_match" | "discovery_match"


# ──────────────────────────────────────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────────────────────────────────────

def _row_to_career_list(row) -> dict:
    return {
        "id":              row.id,
        "slug":            row.slug,
        "name":            row.name,
        "one_liner":       row.one_liner,
        "domain_slug":     row.domain_slug,
        "domain_name":     row.domain_name,
        "dimension_tags":  list(row.dimension_tags or []),
        "india_viability": row.india_viability,
        "future_score":    row.future_score,
        "is_emerging":     row.is_emerging,
    }


# ──────────────────────────────────────────────────────────────────────────────
# Routes
# ──────────────────────────────────────────────────────────────────────────────

@router.get("/domains/", response_model=list[DomainOut])
async def list_domains(db: AsyncSession = Depends(get_db)):
    """Return all active career domains ordered by display_order."""
    result = await db.execute(
        text("""
            SELECT id, slug, name, short_name, india_relevance,
                   growth_forecast_2035, entry_path_summary, display_order
            FROM career_domains
            WHERE is_active = TRUE
            ORDER BY display_order ASC NULLS LAST
        """)
    )
    rows = result.fetchall()
    return [dict(r._mapping) for r in rows]


@router.get("/careers/", response_model=list[CareerListItem])
async def list_careers(
    domain_slug:    Optional[str]  = Query(None, description="Filter by domain slug"),
    india_viability:Optional[str]  = Query(None, description="very_high | high | medium | low | emerging"),
    is_emerging:    Optional[bool] = Query(None, description="True = future careers only"),
    tags:           Optional[str]  = Query(None, description="Comma-separated tags, e.g. C,A"),
    min_score:      int            = Query(1,    ge=1, le=10),
    limit:          int            = Query(50,   ge=1, le=200),
    offset:         int            = Query(0,    ge=0),
    db: AsyncSession = Depends(get_db),
):
    """
    List careers with optional filters.
    Tag filter uses PostgreSQL array overlap: careers whose dimension_tags
    overlap with ANY of the requested tags are returned.
    """
    filters = ["c.is_active = TRUE", "c.future_score >= :min_score"]
    params  = {"min_score": min_score, "limit": limit, "offset": offset}

    if domain_slug:
        filters.append("cd.slug = :domain_slug")
        params["domain_slug"] = domain_slug

    if india_viability:
        filters.append("c.india_viability = :india_viability")
        params["india_viability"] = india_viability

    if is_emerging is not None:
        filters.append("c.is_emerging = :is_emerging")
        params["is_emerging"] = is_emerging

    if tags:
        tag_list = [t.strip().upper() for t in tags.split(",") if t.strip()]
        if tag_list:
            filters.append("c.dimension_tags && :tag_arr::VARCHAR(2)[]")
            params["tag_arr"] = tag_list

    where_clause = " AND ".join(filters)

    result = await db.execute(
        text(f"""
            SELECT c.id, c.slug, c.name, c.one_liner,
                   cd.slug AS domain_slug, cd.name AS domain_name,
                   c.dimension_tags, c.india_viability,
                   c.future_score, c.is_emerging
            FROM careers c
            JOIN career_domains cd ON cd.id = c.domain_id
            WHERE {where_clause}
            ORDER BY c.future_score DESC, c.name ASC
            LIMIT :limit OFFSET :offset
        """),
        params,
    )
    return [_row_to_career_list(r) for r in result.fetchall()]


@router.get("/careers/domain/{domain_slug}", response_model=list[CareerListItem])
async def careers_by_domain(
    domain_slug: str,
    db: AsyncSession = Depends(get_db),
):
    """All active careers in a specific domain."""
    result = await db.execute(
        text("""
            SELECT c.id, c.slug, c.name, c.one_liner,
                   cd.slug AS domain_slug, cd.name AS domain_name,
                   c.dimension_tags, c.india_viability,
                   c.future_score, c.is_emerging
            FROM careers c
            JOIN career_domains cd ON cd.id = c.domain_id
            WHERE cd.slug = :domain_slug AND c.is_active = TRUE
            ORDER BY c.future_score DESC, c.name ASC
        """),
        {"domain_slug": domain_slug},
    )
    rows = result.fetchall()
    if not rows:
        raise HTTPException(status_code=404, detail=f"Domain '{domain_slug}' not found or has no careers.")
    return [_row_to_career_list(r) for r in rows]


@router.get("/careers/{slug}", response_model=CareerDetail)
async def get_career(slug: str, db: AsyncSession = Depends(get_db)):
    """Full detail for a single career by its URL slug."""
    result = await db.execute(
        text("""
            SELECT c.id, c.slug, c.name, c.one_liner,
                   cd.slug AS domain_slug, cd.name AS domain_name,
                   c.dimension_tags, c.india_viability,
                   c.future_score, c.is_emerging,
                   c.typical_day, c.skills_needed, c.entry_paths,
                   c.salary_entry_min_paise, c.salary_entry_max_paise,
                   c.salary_mid_min_paise,   c.salary_mid_max_paise,
                   c.salary_senior_min_paise, c.salary_senior_max_paise,
                   c.future_score_reasoning
            FROM careers c
            JOIN career_domains cd ON cd.id = c.domain_id
            WHERE c.slug = :slug AND c.is_active = TRUE
        """),
        {"slug": slug},
    )
    row = result.fetchone()
    if not row:
        raise HTTPException(status_code=404, detail=f"Career '{slug}' not found.")

    data = dict(row._mapping)
    data["dimension_tags"] = list(data.get("dimension_tags") or [])
    data["skills_needed"]  = list(data.get("skills_needed")  or [])
    data["entry_paths"]    = list(data.get("entry_paths")    or [])
    return data


@router.post("/careers/match/", response_model=list[MatchedCareer])
async def match_careers(
    body: MatchRequest,
    db:   AsyncSession = Depends(get_db),
):
    """
    Given a student's top interest dimensions (e.g. ["C","A","T"]),
    return ranked career matches.

    Tier logic:
      full_match:      3 overlapping tags
      partial_match:   2 overlapping tags
      discovery_match: 1 overlapping tag (only if future_score >= 8)
    """
    dims = [d.upper() for d in body.dimensions if d.strip()][:3]
    if not dims:
        raise HTTPException(status_code=400, detail="Provide at least one dimension tag.")

    emerging_filter = ""
    params: dict = {
        "tag_arr": dims,
        "limit":   body.limit,
    }
    if body.exclude_emerging:
        emerging_filter = "AND c.is_emerging = FALSE"

    result = await db.execute(
        text(f"""
            SELECT
                c.id, c.slug, c.name, c.one_liner,
                cd.slug AS domain_slug, cd.name AS domain_name,
                c.dimension_tags, c.india_viability,
                c.future_score, c.is_emerging,
                -- count how many of the student's tags this career has
                cardinality(
                    ARRAY(
                        SELECT unnest(c.dimension_tags)
                        INTERSECT
                        SELECT unnest(:tag_arr::VARCHAR(2)[])
                    )
                ) AS tag_overlap_count
            FROM careers c
            JOIN career_domains cd ON cd.id = c.domain_id
            WHERE
                c.is_active = TRUE
                AND c.dimension_tags && :tag_arr::VARCHAR(2)[]
                {emerging_filter}
            ORDER BY tag_overlap_count DESC, c.future_score DESC
            LIMIT :limit
        """),
        params,
    )

    rows = result.fetchall()
    out  = []
    for r in rows:
        overlap = r.tag_overlap_count
        if overlap >= 3:
            tier = "full_match"
        elif overlap == 2:
            tier = "partial_match"
        else:
            # discovery_match only if meaningful future score
            if r.future_score < 8:
                continue
            tier = "discovery_match"

        career = _row_to_career_list(r)
        career["tag_overlap_count"] = overlap
        career["match_tier"]        = tier
        out.append(career)

    return out
