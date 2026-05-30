import uuid

from django.conf import settings
from django.db import models


class CareerRecommendation(models.Model):
    class MatchTier(models.TextChoices):
        FULL_MATCH = "full_match", "full_match"
        PARTIAL_MATCH = "partial_match", "partial_match"
        DISCOVERY_MATCH = "discovery_match", "discovery_match"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="career_recommendations",
    )
    interest_profile = models.ForeignKey(
        "profiler.InterestProfile",
        on_delete=models.CASCADE,
        related_name="career_recommendations",
    )
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.CASCADE,
        related_name="recommendations",
    )
    match_score = models.SmallIntegerField()
    match_tier = models.CharField(max_length=20, choices=MatchTier.choices)
    tag_overlap_count = models.SmallIntegerField()
    display_rank = models.SmallIntegerField()
    is_novel = models.BooleanField(default=False)
    generated_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "career_recommendations"
        indexes = [
            models.Index(fields=["user"], name="career_recs_user_idx"),
            models.Index(
                fields=["interest_profile"], name="career_recs_ip_idx"
            ),
        ]

    def __str__(self):
        return f"CareerRecommendation({self.user_id}, {self.career_id})"


class CareerView(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="career_views",
    )
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.CASCADE,
        related_name="views",
    )
    source = models.CharField(max_length=30, blank=True)
    viewed_at = models.DateTimeField(auto_now_add=True)
    time_spent_seconds = models.IntegerField(blank=True, null=True)
    reached_roadmap = models.BooleanField(default=False)

    class Meta:
        db_table = "career_views"
        indexes = [
            models.Index(fields=["user"], name="career_views_user_idx"),
            models.Index(fields=["career"], name="career_views_career_idx"),
        ]

    def __str__(self):
        return f"CareerView({self.user_id}, {self.career_id})"


class CareerSave(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="career_saves",
    )
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.CASCADE,
        related_name="saves",
    )
    saved_at = models.DateTimeField(auto_now_add=True)
    notes = models.TextField(blank=True, null=True)

    class Meta:
        db_table = "career_saves"
        constraints = [
            models.UniqueConstraint(
                fields=["user", "career"],
                name="unique_career_save",
            )
        ]

    def __str__(self):
        return f"CareerSave({self.user_id}, {self.career_id})"
