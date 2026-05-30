import uuid

from django.conf import settings
from django.db import models


class CheckInPrompt(models.Model):
    class PromptType(models.TextChoices):
        CAREER_STILL_INTERESTED = "career_still_interested", "career_still_interested"
        ROADMAP_MILESTONE = "roadmap_milestone", "roadmap_milestone"
        PROFILE_UPDATE = "profile_update", "profile_update"

    class Response(models.TextChoices):
        STILL_YES = "still_yes", "still_yes"
        NOT_SURE = "not_sure", "not_sure"
        MOVED_ON = "moved_on", "moved_on"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="check_in_prompts",
    )
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="check_ins",
    )
    prompt_type = models.CharField(max_length=30, choices=PromptType.choices)
    sent_at = models.DateTimeField(blank=True, null=True)
    responded_at = models.DateTimeField(blank=True, null=True)
    response = models.CharField(max_length=20, choices=Response.choices, blank=True, null=True)

    class Meta:
        db_table = "check_in_prompts"

    def __str__(self):
        return f"CheckInPrompt({self.user_id}, {self.prompt_type})"


class Notification(models.Model):
    class NotificationType(models.TextChoices):
        ROADMAP_REMINDER = "roadmap_reminder", "roadmap_reminder"
        CHECK_IN = "check_in", "check_in"
        NEW_CAREER_MATCH = "new_career_match", "new_career_match"
        SUBSCRIPTION_EXPIRY = "subscription_expiry", "subscription_expiry"
        PROFILER_RETAKE_SUGGESTION = "profiler_retake_suggestion", "profiler_retake_suggestion"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="notifications",
    )
    type = models.CharField(max_length=50, choices=NotificationType.choices)
    title = models.CharField(max_length=200)
    body = models.TextField(blank=True)
    is_read = models.BooleanField(default=False)
    sent_at = models.DateTimeField(auto_now_add=True)
    read_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = "notifications"

    def __str__(self):
        return f"Notification({self.user_id}, {self.type})"
