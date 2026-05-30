from rest_framework import serializers

from apps.ai_chat.models import AIConversation, AIMessage
from apps.careers.models import Career


class CareerSummarySerializer(serializers.ModelSerializer):
	class Meta:
		model = Career
		fields = ["slug", "name"]


class AIMessageSerializer(serializers.ModelSerializer):
	class Meta:
		model = AIMessage
		fields = ["id", "role", "content", "tokens_used", "model_version", "created_at"]


class AIConversationListSerializer(serializers.ModelSerializer):
	career = CareerSummarySerializer(read_only=True)

	class Meta:
		model = AIConversation
		fields = [
			"id",
			"conversation_type",
			"career",
			"title",
			"message_count",
			"last_message_at",
			"is_active",
		]


class AIConversationDetailSerializer(serializers.ModelSerializer):
	career = CareerSummarySerializer(read_only=True)
	messages = AIMessageSerializer(many=True, read_only=True)

	class Meta:
		model = AIConversation
		fields = [
			"id",
			"conversation_type",
			"career",
			"title",
			"message_count",
			"started_at",
			"last_message_at",
			"messages",
		]
