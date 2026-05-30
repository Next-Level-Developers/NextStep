"""
Celery application initialisation.
"""

from celery import Celery

from core.config import settings


celery_app = Celery(
    "nextstep",
    broker=settings.REDIS_URL,
    backend=settings.REDIS_URL,
)

celery_app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="Asia/Kolkata",
    enable_utc=True,
    task_track_started=True,
    task_default_queue="nextstep",
)

# Auto-discover tasks from tasks package
celery_app.autodiscover_tasks(["tasks"])
