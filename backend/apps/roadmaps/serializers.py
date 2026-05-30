from rest_framework import serializers

from apps.roadmaps.models import Roadmap, RoadmapStep, RoadmapStepProgress


class RoadmapStepProgressSerializer(serializers.ModelSerializer):
	class Meta:
		model = RoadmapStepProgress
		fields = ["status", "completed_at", "notes"]


class RoadmapStepSerializer(serializers.ModelSerializer):
	status = serializers.SerializerMethodField()
	completed_at = serializers.SerializerMethodField()

	class Meta:
		model = RoadmapStep
		fields = [
			"id",
			"step_order",
			"category",
			"title",
			"description",
			"timeframe",
			"resource_url",
			"resource_label",
			"is_premium",
			"status",
			"completed_at",
		]

	def get_status(self, obj):
		progress = getattr(obj, "user_progress", None)
		return progress.status if progress else "not_started"

	def get_completed_at(self, obj):
		progress = getattr(obj, "user_progress", None)
		return progress.completed_at if progress else None


class RoadmapSerializer(serializers.ModelSerializer):
	steps = RoadmapStepSerializer(many=True, read_only=True)

	class Meta:
		model = Roadmap
		fields = [
			"id",
			"career_id",
			"academic_stage",
			"generation_method",
			"is_active",
			"generated_at",
			"steps",
		]


class RoadmapListSerializer(serializers.ModelSerializer):
	class Meta:
		model = Roadmap
		fields = [
			"id",
			"career_id",
			"academic_stage",
			"generation_method",
			"is_active",
			"generated_at",
		]
