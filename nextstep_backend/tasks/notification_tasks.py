"""
Notification generation tasks (Celery).
"""

from tasks.celery_app import celery_app


@celery_app.task(name="tasks.send_check_in_prompt")
def send_check_in_prompt(user_id: str, career_id: str):
    """
    Create a check-in prompt for a student about a career they've been exploring.
    """
    pass


@celery_app.task(name="tasks.send_notification")
def send_notification(user_id: str, notification_type: str, title: str, body: str = ""):
    """
    Create an in-app notification.
    """
    pass
