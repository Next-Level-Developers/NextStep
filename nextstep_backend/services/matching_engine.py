"""
Matching engine — cosine similarity + tag overlap for career recommendations.
"""

import math
from typing import List


DIMENSIONS = ["C", "A", "T", "S", "E", "P"]


def cosine_similarity(vec_a: dict, vec_b: dict) -> float:
    """Compute cosine similarity between two dimension score vectors."""
    dot = sum(vec_a.get(d, 0) * vec_b.get(d, 0) for d in DIMENSIONS)
    mag_a = math.sqrt(sum(vec_a.get(d, 0) ** 2 for d in DIMENSIONS))
    mag_b = math.sqrt(sum(vec_b.get(d, 0) ** 2 for d in DIMENSIONS))

    if mag_a == 0 or mag_b == 0:
        return 0.0

    return dot / (mag_a * mag_b)


def tag_overlap(user_dims: List[str], career_tags: List[str]) -> int:
    """Count overlapping dimension tags between user's top dimensions and career."""
    return len(set(user_dims) & set(career_tags))


def compute_match_score(
    user_scores: dict,
    career_tags: List[str],
    user_top_dims: List[str],
) -> tuple[int, str, int]:
    """
    Compute a match score (0–100) for a career.

    Returns: (match_score, match_tier, tag_overlap_count)
    """
    # Build a career "ideal" vector from its tags
    career_vec = {d: (100 if d in career_tags else 0) for d in DIMENSIONS}

    similarity = cosine_similarity(user_scores, career_vec)
    overlap = tag_overlap(user_top_dims, career_tags)

    # Weighted score: 70% cosine + 30% tag overlap
    max_overlap = min(len(user_top_dims), len(career_tags)) or 1
    overlap_score = (overlap / max_overlap) * 100
    match_score = int(similarity * 70 + (overlap_score * 0.3))
    match_score = min(100, max(0, match_score))

    # Determine tier
    if overlap >= 2 and match_score >= 60:
        tier = "full_match"
    elif overlap >= 1 and match_score >= 40:
        tier = "partial_match"
    else:
        tier = "discovery_match"

    return match_score, tier, overlap
