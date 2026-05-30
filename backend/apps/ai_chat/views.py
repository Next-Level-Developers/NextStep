from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.ai_chat.ai_service import generate_response
from apps.ai_chat.context_builder import build_system_prompt
from apps.ai_chat.models import AIConversation, AIMessage
from apps.ai_chat.serializers import (
	AIConversationDetailSerializer,
	AIConversationListSerializer,
)
from apps.careers.models import Career
from apps.profiler.models import InterestProfile
from apps.recommendations.models import CareerSave
from utils.responses import error_response, success_response


class ConversationListCreateView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		conversation_type = request.query_params.get("conversation_type")
		queryset = AIConversation.objects.filter(user=request.user)
		if conversation_type:
			queryset = queryset.filter(conversation_type=conversation_type)
		data = AIConversationListSerializer(queryset, many=True).data
		return success_response(data)

	def post(self, request):
		conversation_type = request.data.get("conversation_type")
		career_slug = request.data.get("career_slug")
		first_message = request.data.get("first_message")
		if not conversation_type or not first_message:
			return error_response(
				"VALIDATION_ERROR",
				"conversation_type and first_message are required.",
				status=status.HTTP_400_BAD_REQUEST,
			)

		career = None
		if conversation_type == "career_specific" and career_slug:
			career = Career.objects.filter(slug=career_slug).first()
			if not career:
				return error_response(
					"CAREER_NOT_FOUND",
					"Career slug doesn't exist.",
					status=status.HTTP_404_NOT_FOUND,
				)

		interest_profile = InterestProfile.objects.filter(
			user=request.user, is_active=True
		).first()
		student_profile = getattr(request.user, "student_profile", None)
		saved_careers = CareerSave.objects.filter(user=request.user).select_related("career")

		system_prompt = build_system_prompt(
			request.user, career, interest_profile, student_profile, saved_careers
		)
		assistant_reply = generate_response(system_prompt, [first_message])

		conversation = AIConversation.objects.create(
			user=request.user,
			conversation_type=conversation_type,
			career=career,
			title=first_message,
			last_message_at=timezone.now(),
			message_count=2,
		)
		AIMessage.objects.create(
			conversation=conversation,
			role=AIMessage.Role.USER,
			content=first_message,
		)
		AIMessage.objects.create(
			conversation=conversation,
			role=AIMessage.Role.ASSISTANT,
			content=assistant_reply,
			tokens_used=None,
			model_version=None,
		)

		data = AIConversationDetailSerializer(conversation).data
		return success_response(data, status=status.HTTP_201_CREATED)


class ConversationDetailView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request, conversation_id):
		conversation = AIConversation.objects.filter(
			id=conversation_id, user=request.user
		).first()
		if not conversation:
			return error_response(
				"CONVERSATION_NOT_FOUND",
				"Conversation not found.",
				status=status.HTTP_404_NOT_FOUND,
			)
		data = AIConversationDetailSerializer(conversation).data
		return success_response(data)

	def delete(self, request, conversation_id):
		conversation = AIConversation.objects.filter(
			id=conversation_id, user=request.user
		).first()
		if not conversation:
			return error_response(
				"CONVERSATION_NOT_FOUND",
				"Conversation not found.",
				status=status.HTTP_404_NOT_FOUND,
			)
		conversation.is_active = False
		conversation.save(update_fields=["is_active"])
		return Response(status=status.HTTP_204_NO_CONTENT)


class ConversationMessageCreateView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request, conversation_id):
		conversation = AIConversation.objects.filter(
			id=conversation_id, user=request.user
		).first()
		if not conversation:
			return error_response(
				"CONVERSATION_NOT_FOUND",
				"Conversation not found.",
				status=status.HTTP_404_NOT_FOUND,
			)

		content = request.data.get("content")
		if not content:
			return error_response(
				"VALIDATION_ERROR",
				"content is required.",
				status=status.HTTP_400_BAD_REQUEST,
			)

		system_prompt = build_system_prompt(request.user)
		assistant_reply = generate_response(system_prompt, [content])

		user_message = AIMessage.objects.create(
			conversation=conversation,
			role=AIMessage.Role.USER,
			content=content,
		)
		assistant_message = AIMessage.objects.create(
			conversation=conversation,
			role=AIMessage.Role.ASSISTANT,
			content=assistant_reply,
		)

		conversation.last_message_at = timezone.now()
		conversation.message_count = conversation.message_count + 2
		conversation.save(update_fields=["last_message_at", "message_count"])

		data = {
			"user_message": {
				"id": str(user_message.id),
				"role": user_message.role,
				"content": user_message.content,
				"created_at": user_message.created_at,
			},
			"assistant_message": {
				"id": str(assistant_message.id),
				"role": assistant_message.role,
				"content": assistant_message.content,
				"tokens_used": assistant_message.tokens_used,
				"model_version": assistant_message.model_version,
				"created_at": assistant_message.created_at,
			},
		}
		return success_response(data, status=status.HTTP_201_CREATED)
