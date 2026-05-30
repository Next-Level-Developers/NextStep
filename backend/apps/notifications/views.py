from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from apps.careers.models import Career
from apps.notifications.models import CheckInPrompt, Notification
from apps.notifications.serializers import NotificationSerializer
from utils.responses import error_response, success_response


class NotificationListView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		queryset = Notification.objects.filter(user=request.user).order_by("-sent_at")
		is_read = request.query_params.get("is_read")
		if is_read in {"true", "false"}:
			queryset = queryset.filter(is_read=is_read == "true")

		data = {
			"unread_count": Notification.objects.filter(
				user=request.user, is_read=False
			).count(),
			"results": NotificationSerializer(queryset, many=True).data,
		}
		return success_response(data)


class NotificationReadView(APIView):
	permission_classes = [IsAuthenticated]

	def patch(self, request, notification_id):
		notification = Notification.objects.filter(
			id=notification_id, user=request.user
		).first()
		if not notification:
			return error_response(
				"NOTIFICATION_NOT_FOUND",
				"Notification not found.",
				status=status.HTTP_404_NOT_FOUND,
			)
		notification.is_read = True
		notification.read_at = timezone.now()
		notification.save(update_fields=["is_read", "read_at"])
		return success_response(
			{
				"id": str(notification.id),
				"is_read": notification.is_read,
				"read_at": notification.read_at,
			}
		)


class NotificationMarkAllReadView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request):
		updated = Notification.objects.filter(user=request.user, is_read=False).update(
			is_read=True, read_at=timezone.now()
		)
		return success_response({"marked_read_count": updated})


class CheckInListView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		check_ins = CheckInPrompt.objects.filter(user=request.user, responded_at__isnull=True)
		data = []
		for check_in in check_ins:
			career = Career.objects.filter(id=check_in.career_id).first()
			data.append(
				{
					"id": str(check_in.id),
					"prompt_type": check_in.prompt_type,
					"career": {
						"slug": career.slug,
						"name": career.name,
					}
					if career
					else None,
					"question": "It's been a month since you added this career. Still interested?",
					"options": [
						{"value": "still_yes", "label": "Yes, definitely!"},
						{"value": "not_sure", "label": "I'm not sure anymore"},
						{"value": "moved_on", "label": "I've moved on to something else"},
					],
					"sent_at": check_in.sent_at,
				}
			)
		return success_response(data)


class CheckInRespondView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request, check_in_id):
		check_in = CheckInPrompt.objects.filter(id=check_in_id, user=request.user).first()
		if not check_in:
			return error_response(
				"CHECK_IN_NOT_FOUND",
				"Check-in prompt not found.",
				status=status.HTTP_404_NOT_FOUND,
			)
		response_value = request.data.get("response")
		check_in.response = response_value
		check_in.responded_at = timezone.now()
		check_in.save(update_fields=["response", "responded_at"])
		return success_response(
			{
				"check_in_id": str(check_in.id),
				"response": check_in.response,
				"responded_at": check_in.responded_at,
				"next_action": None,
			}
		)
