from django.contrib.auth import get_user_model
from rest_framework import serializers

from apps.users.models import StudentProfile

User = get_user_model()


class StudentProfileSerializer(serializers.ModelSerializer):
	class Meta:
		model = StudentProfile
		fields = [
			"id",
			"user_id",
			"academic_stage",
			"grade_or_year",
			"school_name",
			"city",
			"state",
			"career_clarity",
			"pressure_level",
			"career_awareness_level",
			"profiler_completed",
			"profiler_completed_at",
		]
		read_only_fields = ["id", "user_id", "profiler_completed", "profiler_completed_at"]


class UserSerializer(serializers.ModelSerializer):
	student_profile = StudentProfileSerializer(read_only=True)

	class Meta:
		model = User
		fields = [
			"id",
			"email",
			"full_name",
			"phone",
			"avatar_url",
			"user_type",
			"subscription_tier",
			"subscription_expires_at",
			"parental_consent_given",
			"parental_consent_at",
			"created_at",
			"student_profile",
		]


class UserUpdateSerializer(serializers.ModelSerializer):
	class Meta:
		model = User
		fields = ["full_name", "phone"]


class FirebaseAuthSerializer(serializers.Serializer):
	firebase_token = serializers.CharField()


class ParentalConsentSerializer(serializers.Serializer):
	consent_given = serializers.BooleanField()
	parent_name = serializers.CharField(required=False, allow_blank=True)
	parent_phone = serializers.CharField(required=False, allow_blank=True)


class AvatarUploadSerializer(serializers.Serializer):
	file = serializers.ImageField()


class ShareTokenSerializer(serializers.Serializer):
	share_token = serializers.CharField(read_only=True)
	share_url = serializers.CharField(read_only=True)
	expires_at = serializers.DateTimeField(read_only=True)
