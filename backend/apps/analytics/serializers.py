from rest_framework import serializers

from apps.analytics.models import AnalyticsEvent


class AnalyticsEventSerializer(serializers.ModelSerializer):
	class Meta:
		model = AnalyticsEvent
		fields = [
			"id",
			"event_name",
			"session_id",
			"career_id",
			"properties",
			"occurred_at",
		]
