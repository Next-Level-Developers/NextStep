import uuid

from django.conf import settings
from django.db import models


class AnalyticsEvent(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="analytics_events",
    )
    session_id = models.CharField(max_length=100, blank=True, null=True)
    event_name = models.CharField(max_length=100)
    properties = models.JSONField(blank=True, null=True)
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="analytics_events",
    )
    organisation_id = models.UUIDField(blank=True, null=True)
    occurred_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "analytics_events"
        indexes = [
            models.Index(fields=["user"], name="analytics_events_user_idx"),
            models.Index(fields=["event_name"], name="analytics_events_event_idx"),
            models.Index(fields=["occurred_at"], name="analytics_events_occurred_idx"),
        ]

    def __str__(self):
        return f"AnalyticsEvent({self.event_name})"
