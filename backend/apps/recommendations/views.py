from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from apps.recommendations.models import CareerRecommendation, CareerSave
from apps.recommendations.serializers import (
	CareerRecommendationSerializer,
	SavedCareerSerializer,
)
from utils.responses import error_response, success_response


class RecommendationsListView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		queryset = CareerRecommendation.objects.filter(user=request.user).select_related(
			"career", "career__domain"
		)

		tier = request.query_params.get("tier")
		if tier:
			queryset = queryset.filter(match_tier=tier)

		limit = int(request.query_params.get("limit", 15))
		results = queryset.order_by("display_rank")[:limit]
		data = {
			"interest_profile_id": str(results[0].interest_profile_id) if results else None,
			"generated_at": results[0].generated_at if results else None,
			"total_matches": queryset.count(),
			"recommendations": CareerRecommendationSerializer(results, many=True).data,
		}
		return success_response(data)


class RecommendationsRegenerateView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request):
		return success_response({"status": "regenerating", "eta_seconds": 3})


class SavedCareersView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		queryset = CareerSave.objects.filter(user=request.user).select_related(
			"career", "career__domain"
		)
		data = {
			"count": queryset.count(),
			"results": SavedCareerSerializer(queryset, many=True).data,
		}
		return success_response(data)
