import uuid

from django.conf import settings
from django.db import models
from django.db.models import Q


class Roadmap(models.Model):
    class GenerationMethod(models.TextChoices):
        TEMPLATE = "template", "template"
        AI_GENERATED = "ai_generated", "ai_generated"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="roadmaps",
    )
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.CASCADE,
        related_name="roadmaps",
    )
    interest_profile = models.ForeignKey(
        "profiler.InterestProfile",
        on_delete=models.CASCADE,
        related_name="roadmaps",
    )
    academic_stage = models.CharField(max_length=30)
    generation_method = models.CharField(
        max_length=20, choices=GenerationMethod.choices, default=GenerationMethod.TEMPLATE
    )
    is_active = models.BooleanField(default=True)
    generated_at = models.DateTimeField(auto_now_add=True)
    last_updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "roadmaps"
        constraints = [
            models.UniqueConstraint(
                fields=["user", "career"],
                condition=Q(is_active=True),
                name="unique_active_roadmap_per_user_career",
            )
        ]

    def __str__(self):
        return f"Roadmap({self.user_id}, {self.career_id})"


class RoadmapStep(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    roadmap = models.ForeignKey(
        "roadmaps.Roadmap",
        on_delete=models.CASCADE,
        related_name="steps",
    )
    step_order = models.SmallIntegerField()
    category = models.CharField(max_length=30)
    title = models.CharField(max_length=300)
    description = models.TextField(blank=True, null=True)
    timeframe = models.CharField(max_length=50, blank=True, null=True)
    resource_url = models.TextField(blank=True, null=True)
    resource_label = models.CharField(max_length=200, blank=True, null=True)
    is_premium = models.BooleanField(default=False)

    class Meta:
        db_table = "roadmap_steps"
        indexes = [
            models.Index(fields=["roadmap"], name="roadmap_steps_roadmap_idx"),
        ]

    def __str__(self):
        return f"RoadmapStep({self.roadmap_id}, {self.step_order})"


class RoadmapStepProgress(models.Model):
    class Status(models.TextChoices):
        NOT_STARTED = "not_started", "not_started"
        IN_PROGRESS = "in_progress", "in_progress"
        COMPLETED = "completed", "completed"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="roadmap_step_progress",
    )
    roadmap_step = models.ForeignKey(
        "roadmaps.RoadmapStep",
        on_delete=models.CASCADE,
        related_name="progress",
    )
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.NOT_STARTED)
    completed_at = models.DateTimeField(blank=True, null=True)
    notes = models.TextField(blank=True, null=True)

    class Meta:
        db_table = "roadmap_step_progress"
        constraints = [
            models.UniqueConstraint(
                fields=["user", "roadmap_step"],
                name="unique_roadmap_step_progress",
            )
        ]
        indexes = [
            models.Index(fields=["user"], name="roadmap_step_progress_user_idx"),
        ]

    def __str__(self):
        return f"RoadmapStepProgress({self.user_id}, {self.roadmap_step_id})"
