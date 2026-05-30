from rest_framework import serializers

from apps.profiler.models import InterestProfile, ProfilerResponse, ProfilerSession


class ProfilerSessionSerializer(serializers.ModelSerializer):
	class Meta:
		model = ProfilerSession
		fields = [
			"id",
			"session_number",
			"status",
			"total_questions",
			"questions_answered",
			"questions_skipped",
			"started_at",
			"completed_at",
			"time_taken_seconds",
		]


class ProfilerResponseSerializer(serializers.ModelSerializer):
	class Meta:
		model = ProfilerResponse
		fields = [
			"id",
			"session_id",
			"question_code",
			"question_section",
			"selected_option_index",
			"dimension_weights",
			"skipped",
			"answered_at",
		]


class InterestProfileSerializer(serializers.ModelSerializer):
	class Meta:
		model = InterestProfile
		fields = [
			"id",
			"session_id",
			"is_active",
			"dimension_scores",
			"top_dimensions",
			"career_cluster_weights",
			"awareness_known_careers",
			"computed_at",
		]
