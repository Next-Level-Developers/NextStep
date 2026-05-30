import uuid

from django.conf import settings
from django.contrib.postgres.fields import ArrayField
from django.db import models


class ProfilerSession(models.Model):
    class Status(models.TextChoices):
        IN_PROGRESS = "in_progress", "in_progress"
        COMPLETED = "completed", "completed"
        ABANDONED = "abandoned", "abandoned"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="profiler_sessions",
    )
    session_number = models.SmallIntegerField(default=1)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.IN_PROGRESS)
    total_questions = models.SmallIntegerField(default=24)
    questions_answered = models.SmallIntegerField(default=0)
    questions_skipped = models.SmallIntegerField(default=0)
    started_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(blank=True, null=True)
    time_taken_seconds = models.IntegerField(blank=True, null=True)

    class Meta:
        db_table = "profiler_sessions"
        indexes = [
            models.Index(fields=["user"], name="profiler_sessions_user_idx"),
            models.Index(fields=["status"], name="profiler_sessions_status_idx"),
        ]

    def __str__(self):
        return f"ProfilerSession({self.user_id}, {self.session_number})"


class ProfilerResponse(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    session = models.ForeignKey(
        "profiler.ProfilerSession",
        on_delete=models.CASCADE,
        related_name="responses",
    )
    question_code = models.CharField(max_length=10)
    question_section = models.CharField(max_length=30)
    selected_option_index = ArrayField(models.SmallIntegerField(), default=list)
    dimension_weights = models.JSONField()
    skipped = models.BooleanField(default=False)
    answered_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "profiler_responses"
        indexes = [
            models.Index(fields=["session"], name="profiler_responses_session_idx"),
        ]

    def __str__(self):
        return f"ProfilerResponse({self.session_id}, {self.question_code})"


class InterestProfile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="interest_profiles",
    )
    session = models.OneToOneField(
        "profiler.ProfilerSession",
        on_delete=models.CASCADE,
        related_name="interest_profile",
    )
    is_active = models.BooleanField(default=True)
    dimension_scores = models.JSONField()
    top_dimensions = ArrayField(models.CharField(max_length=2))
    career_cluster_weights = models.JSONField()
    awareness_known_careers = ArrayField(models.CharField(max_length=100), blank=True, null=True)
    computed_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "interest_profiles"
        indexes = [
            models.Index(fields=["user"], name="interest_profiles_user_idx"),
            models.Index(fields=["is_active"], name="ip_is_active_idx"),
        ]

    def __str__(self):
        return f"InterestProfile({self.user_id}, active={self.is_active})"
