"""
Recommendation generation tasks (Celery).
"""

from tasks.celery_app import celery_app


@celery_app.task(name="tasks.generate_recommendations")
def generate_recommendations(user_id: str, interest_profile_id: str):
    """
    Async task: compute career matches for a user based on their interest profile.

    In production, this reads all careers, computes cosine similarity,
    and writes CareerRecommendation rows.
    """
    # Placeholder — in production this runs the matching engine
    pass


@celery_app.task(name="tasks.regenerate_recommendations")
def regenerate_recommendations(user_id: str):
    """
    Re-run matching with the latest interest profile.
    """
    pass
