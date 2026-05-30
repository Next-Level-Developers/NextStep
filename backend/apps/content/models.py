import uuid

from django.contrib.postgres.fields import ArrayField
from django.db import models


class RealPeopleStory(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.CASCADE,
        related_name="real_people_stories",
    )
    person_name = models.CharField(max_length=150)
    person_age = models.SmallIntegerField(blank=True, null=True)
    person_city = models.CharField(max_length=100, blank=True, null=True)
    person_background = models.CharField(max_length=300, blank=True, null=True)
    story_text = models.TextField()
    is_premium = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "real_people_stories"

    def __str__(self):
        return f"RealPeopleStory({self.career_id}, {self.person_name})"


class LearningResource(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=300)
    url = models.TextField()
    provider = models.CharField(max_length=150, blank=True)
    resource_type = models.CharField(max_length=30, blank=True)
    career_ids = ArrayField(models.UUIDField(), blank=True, null=True)
    skill_tags = ArrayField(models.TextField(), blank=True, null=True)
    is_free = models.BooleanField(default=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "learning_resources"

    def __str__(self):
        return self.title
