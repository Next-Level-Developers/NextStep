from rest_framework import serializers

from apps.careers.serializers import CareerListSerializer
from apps.recommendations.models import CareerRecommendation, CareerSave


class CareerRecommendationSerializer(serializers.ModelSerializer):
	career = CareerListSerializer(read_only=True)

	class Meta:
		model = CareerRecommendation
		fields = [
			"display_rank",
			"match_score",
			"match_tier",
			"tag_overlap_count",
			"is_novel",
			"career",
		]


class SavedCareerSerializer(serializers.ModelSerializer):
	career = CareerListSerializer(read_only=True)

	class Meta:
		model = CareerSave
		fields = ["id", "saved_at", "notes", "career"]
