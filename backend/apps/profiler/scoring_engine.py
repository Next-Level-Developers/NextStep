from collections import defaultdict

from apps.profiler.models import ProfilerResponse


DIMENSIONS = ["C", "A", "T", "S", "E", "P"]


def compute_dimension_scores(session_id):
    responses = ProfilerResponse.objects.filter(session_id=session_id)
    totals = defaultdict(float)
    for response in responses:
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
