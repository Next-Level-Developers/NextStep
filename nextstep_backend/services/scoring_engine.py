"""
Scoring engine — computes dimension scores from profiler responses.

Async port of apps/profiler/scoring_engine.py.
"""

from collections import defaultdict
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from models.profiler import ProfilerResponse


DIMENSIONS = ["C", "A", "T", "S", "E", "P"]


async def compute_dimension_scores(db: AsyncSession, session_id: UUID) -> dict[str, int]:
    """
    Compute normalised dimension scores (0–100) from profiler responses.

    Aggregates all dimension_weights across responses, then normalises
    relative to the maximum score.
    """
    stmt = select(ProfilerResponse).where(ProfilerResponse.session_id == session_id)
    result = await db.execute(stmt)
    responses = result.scalars().all()

    totals = defaultdict(float)
    for response in responses:
        if response.dimension_weights:
            for key, value in response.dimension_weights.items():
                totals[key] += float(value)

    if not totals:
        return {key: 0 for key in DIMENSIONS}

    max_score = max(totals.values()) or 1
    normalised = {}
    for key in DIMENSIONS:
        raw = totals.get(key, 0)
        normalised[key] = int((raw / max_score) * 100)

    return normalised
