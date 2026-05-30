from rest_framework import serializers

from apps.notifications.models import CheckInPrompt, Notification


class NotificationSerializer(serializers.ModelSerializer):
	class Meta:
		model = Notification
		fields = [
			"id",
			"type",
			"title",
			"body",
			"is_read",
			"sent_at",
			"read_at",
		]


class CheckInPromptSerializer(serializers.ModelSerializer):
	class Meta:
		model = CheckInPrompt
		fields = [
			"id",
			"prompt_type",
			"career_id",
			"sent_at",
			"responded_at",
			"response",
		]
