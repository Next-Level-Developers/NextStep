import uuid

from django.contrib.postgres.fields import ArrayField
from django.db import models


class CareerDomain(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    slug = models.CharField(max_length=80, unique=True)
    name = models.CharField(max_length=150)
    short_name = models.CharField(max_length=60)
    india_relevance = models.CharField(max_length=20, blank=True)
    growth_forecast_2035 = models.CharField(max_length=20, blank=True)
    entry_path_summary = models.CharField(max_length=300, blank=True)
    display_order = models.SmallIntegerField(blank=True, null=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = "career_domains"

    def __str__(self):
        return self.name


class CareerCluster(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100)
    q24_description = models.TextField(blank=True)
    domain_ids = ArrayField(models.UUIDField(), blank=True, null=True)

    class Meta:
        db_table = "career_clusters"

    def __str__(self):
        return self.name


class Career(models.Model):
    class IndiaViability(models.TextChoices):
        VERY_HIGH = "very_high", "very_high"
        HIGH = "high", "high"
        MEDIUM = "medium", "medium"
        LOW = "low", "low"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    slug = models.CharField(max_length=100, unique=True)
    name = models.CharField(max_length=150)
    one_liner = models.CharField(max_length=300)
    domain = models.ForeignKey(
        "careers.CareerDomain",
        on_delete=models.CASCADE,
        related_name="careers",
    )
    dimension_tags = ArrayField(models.CharField(max_length=2))
    india_viability = models.CharField(max_length=20, choices=IndiaViability.choices)
    future_score = models.SmallIntegerField()
    future_score_reasoning = models.TextField(blank=True, null=True)
    typical_day = models.TextField(blank=True, null=True)
    skills_needed = ArrayField(models.TextField(), blank=True, null=True)
    entry_paths = ArrayField(models.TextField(), blank=True, null=True)
    salary_entry_min_paise = models.BigIntegerField(blank=True, null=True)
    salary_entry_max_paise = models.BigIntegerField(blank=True, null=True)
    salary_mid_min_paise = models.BigIntegerField(blank=True, null=True)
    salary_mid_max_paise = models.BigIntegerField(blank=True, null=True)
    salary_senior_min_paise = models.BigIntegerField(blank=True, null=True)
    salary_senior_max_paise = models.BigIntegerField(blank=True, null=True)
    related_career_ids = ArrayField(models.UUIDField(), blank=True, null=True)
    is_emerging = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    last_reviewed_at = models.DateField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "careers"
        indexes = [
            models.Index(fields=["slug"], name="careers_slug_idx"),
            models.Index(fields=["domain"], name="careers_domain_idx"),
            models.Index(fields=["future_score"], name="careers_future_score_idx"),
            models.Index(fields=["india_viability"], name="careers_india_viability_idx"),
        ]

    def __str__(self):
        return self.name
