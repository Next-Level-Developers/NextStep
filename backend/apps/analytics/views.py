from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from apps.analytics.models import AnalyticsEvent
from apps.analytics.serializers import AnalyticsEventSerializer
from utils.responses import success_response


class AnalyticsEventCreateView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request):
		payload = {
			"user": request.user,
			"event_name": request.data.get("event_name"),
			"session_id": request.data.get("session_id"),
			"career_id": request.data.get("career_id"),
			"properties": request.data.get("properties", {}),
		}
		event = AnalyticsEvent.objects.create(**payload)
		return success_response({"event_id": str(event.id)}, status=status.HTTP_201_CREATED)
