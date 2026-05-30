import uuid

from django.conf import settings
from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from django.db import models


class UserManager(BaseUserManager):
    def create_user(self, email, firebase_uid, password=None, **extra_fields):
        if not email:
            raise ValueError("Email is required.")
        if not firebase_uid:
            raise ValueError("Firebase UID is required.")

        email = self.normalize_email(email)
        user = self.model(email=email, firebase_uid=firebase_uid, **extra_fields)
        if password:
            user.set_password(password)
        else:
            user.set_unusable_password()
        user.save(using=self._db)
        return user

    def create_superuser(self, email, firebase_uid, password, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")

        return self.create_user(email, firebase_uid, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    class UserType(models.TextChoices):
        STUDENT = "student", "student"
        PARENT = "parent", "parent"
        COUNSELLOR = "counsellor", "counsellor"
        SCHOOL_ADMIN = "school_admin", "school_admin"

    class SubscriptionTier(models.TextChoices):
        FREE = "free", "free"
        PREMIUM = "premium", "premium"
        SCHOOL = "school", "school"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    firebase_uid = models.CharField(max_length=128, unique=True)
    email = models.EmailField(unique=True)
    full_name = models.CharField(max_length=200, blank=True, null=True)
    phone = models.CharField(max_length=20, blank=True, null=True)
    avatar_url = models.TextField(blank=True, null=True)
    user_type = models.CharField(max_length=20, choices=UserType.choices)
    subscription_tier = models.CharField(
        max_length=20, choices=SubscriptionTier.choices, default=SubscriptionTier.FREE
    )
    subscription_expires_at = models.DateTimeField(blank=True, null=True)
    parental_consent_given = models.BooleanField(default=False)
    parental_consent_at = models.DateTimeField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    objects = UserManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["firebase_uid"]

    class Meta:
        db_table = "users"
        indexes = [
            models.Index(fields=["firebase_uid"], name="users_firebase_uid_idx"),
            models.Index(fields=["email"], name="users_email_idx"),
            models.Index(fields=["subscription_tier"], name="users_subscription_tier_idx"),
        ]

    def __str__(self):
        return self.email


class StudentProfile(models.Model):
    class AcademicStage(models.TextChoices):
        GRADE_8_9 = "grade_8_9", "grade_8_9"
        GRADE_10 = "grade_10", "grade_10"
        GRADE_11_12_SCIENCE = "grade_11_12_science", "grade_11_12_science"
        GRADE_11_12_COMMERCE = "grade_11_12_commerce", "grade_11_12_commerce"
        GRADE_11_12_ARTS = "grade_11_12_arts", "grade_11_12_arts"
        COLLEGE_YEAR_1_2 = "college_year_1_2", "college_year_1_2"

    class CareerClarity(models.TextChoices):
        CLEAR = "clear", "clear"
        FEW_OPTIONS = "few_options", "few_options"
        NONE = "none", "none"
        WANTS_TO_EXPLORE = "wants_to_explore", "wants_to_explore"

    class PressureLevel(models.TextChoices):
        HIGH = "high", "high"
        SOME = "some", "some"
        LOW = "low", "low"
        VERY_HIGH = "very_high", "very_high"

    class CareerAwarenessLevel(models.TextChoices):
        NARROW = "narrow", "narrow"
        MODERATE = "moderate", "moderate"
        BROAD = "broad", "broad"
        FOCUSED = "focused", "focused"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="student_profile",
    )
    academic_stage = models.CharField(max_length=30, choices=AcademicStage.choices)
    grade_or_year = models.CharField(max_length=10, blank=True, null=True)
    school_name = models.CharField(max_length=255, blank=True, null=True)
    city = models.CharField(max_length=100, blank=True, null=True)
    state = models.CharField(max_length=100, blank=True, null=True)
    career_clarity = models.CharField(
        max_length=30, choices=CareerClarity.choices, blank=True, null=True
    )
    pressure_level = models.CharField(
        max_length=20, choices=PressureLevel.choices, blank=True, null=True
    )
    career_awareness_level = models.CharField(
        max_length=20, choices=CareerAwarenessLevel.choices, blank=True, null=True
    )
    profiler_completed = models.BooleanField(default=False)
    profiler_completed_at = models.DateTimeField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "student_profiles"

    def __str__(self):
        return f"StudentProfile({self.user_id})"


class SchoolOrganisation(models.Model):
    class OrganisationType(models.TextChoices):
        SCHOOL = "school", "school"
        COACHING_INSTITUTE = "coaching_institute", "coaching_institute"
        COLLEGE = "college", "college"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    type = models.CharField(max_length=30, choices=OrganisationType.choices)
    city = models.CharField(max_length=100, blank=True)
    state = models.CharField(max_length=100, blank=True)
    contact_email = models.EmailField(blank=True)
    licence_seats = models.IntegerField(default=0)
    licence_expires_at = models.DateTimeField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "school_organisations"

    def __str__(self):
        return self.name


class SchoolMembership(models.Model):
    class Role(models.TextChoices):
        STUDENT = "student", "student"
        COUNSELLOR = "counsellor", "counsellor"
        ADMIN = "admin", "admin"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="school_memberships",
    )
    organisation = models.ForeignKey(
        "users.SchoolOrganisation",
        on_delete=models.CASCADE,
        related_name="memberships",
    )
    role = models.CharField(max_length=20, choices=Role.choices)
    joined_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "school_memberships"
        constraints = [
            models.UniqueConstraint(
                fields=["user", "organisation"],
                name="unique_school_membership",
            )
        ]

    def __str__(self):
        return f"SchoolMembership({self.user_id}, {self.organisation_id})"
