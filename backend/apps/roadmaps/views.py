from django.db import transaction
from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from apps.careers.models import Career
from apps.profiler.models import InterestProfile
from apps.roadmaps.generator import get_template_steps
from apps.roadmaps.models import Roadmap, RoadmapStep, RoadmapStepProgress
from apps.roadmaps.serializers import RoadmapSerializer
from utils.responses import error_response, success_response


class RoadmapListCreateView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		roadmaps = Roadmap.objects.filter(user=request.user).select_related("career")
		data = []
		for roadmap in roadmaps:
			steps = RoadmapStep.objects.filter(roadmap=roadmap)
			completed = RoadmapStepProgress.objects.filter(
				user=request.user, roadmap_step__roadmap=roadmap, status="completed"
			).count()
			total = steps.count()
			data.append(
				{
					"id": str(roadmap.id),
					"career": {
						"slug": roadmap.career.slug,
						"name": roadmap.career.name,
						"domain_short_name": roadmap.career.domain.short_name,
					},
					"academic_stage": roadmap.academic_stage,
					"generation_method": roadmap.generation_method,
					"is_active": roadmap.is_active,
					"total_steps": total,
					"completed_steps": completed,
					"completion_percent": int((completed / total) * 100) if total else 0,
					"generated_at": roadmap.generated_at,
				}
			)
		return success_response(data)

	def post(self, request):
		career_slug = request.data.get("career_slug")
		career = Career.objects.filter(slug=career_slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)

		existing = Roadmap.objects.filter(
			user=request.user, career=career, is_active=True
		).first()
		if existing:
			return success_response(RoadmapSerializer(existing).data)

		profile = InterestProfile.objects.filter(user=request.user, is_active=True).first()
		academic_stage = getattr(request.user.student_profile, "academic_stage", None)

		with transaction.atomic():
			roadmap = Roadmap.objects.create(
				user=request.user,
				career=career,
				interest_profile=profile,
				academic_stage=academic_stage or "",
			)
			steps = get_template_steps(career.slug, academic_stage)
			for index, step in enumerate(steps, start=1):
				RoadmapStep.objects.create(
					roadmap=roadmap,
					step_order=index,
					category=step.get("category", "skill_to_learn"),
					title=step.get("title", ""),
					description=step.get("description"),
					timeframe=step.get("timeframe"),
					resource_url=step.get("resource_url"),
					resource_label=step.get("resource_label"),
					is_premium=bool(step.get("is_premium", False)),
				)

		return success_response(RoadmapSerializer(roadmap).data, status=status.HTTP_201_CREATED)


class RoadmapDetailView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request, roadmap_id):
		roadmap = Roadmap.objects.filter(id=roadmap_id, user=request.user).first()
		if not roadmap:
			return error_response(
				"ROADMAP_NOT_FOUND",
				"Roadmap not found.",
				status=status.HTTP_404_NOT_FOUND,
			)

		steps = list(RoadmapStep.objects.filter(roadmap=roadmap).order_by("step_order"))
		progress_map = {
			progress.roadmap_step_id: progress
			for progress in RoadmapStepProgress.objects.filter(
				user=request.user, roadmap_step__roadmap=roadmap
			)
		}
		for step in steps:
			step.user_progress = progress_map.get(step.id)
		data = RoadmapSerializer(roadmap).data
		data["steps"] = []
		for step in steps:
			data["steps"].append(
				{
					"id": str(step.id),
					"step_order": step.step_order,
					"category": step.category,
					"title": step.title,
					"description": step.description,
					"timeframe": step.timeframe,
					"resource_url": step.resource_url,
					"resource_label": step.resource_label,
					"is_premium": step.is_premium,
					"status": step.user_progress.status if step.user_progress else "not_started",
					"completed_at": step.user_progress.completed_at
					if step.user_progress
					else None,
				}
			)
		return success_response(data)


class RoadmapStepProgressView(APIView):
	permission_classes = [IsAuthenticated]

	def patch(self, request, roadmap_id, step_id):
		step = RoadmapStep.objects.filter(id=step_id, roadmap_id=roadmap_id).first()
		if not step:
			return error_response(
				"ROADMAP_STEP_NOT_FOUND",
				"Roadmap step not found.",
				status=status.HTTP_404_NOT_FOUND,
			)

		status_value = request.data.get("status", "not_started")
		notes = request.data.get("notes")
		progress, _ = RoadmapStepProgress.objects.get_or_create(
			user=request.user, roadmap_step=step
		)
		progress.status = status_value
		progress.notes = notes
		if status_value == RoadmapStepProgress.Status.COMPLETED:
			progress.completed_at = timezone.now()
		progress.save()

		total_steps = RoadmapStep.objects.filter(roadmap_id=roadmap_id).count()
		completed_steps = RoadmapStepProgress.objects.filter(
			user=request.user,
			roadmap_step__roadmap_id=roadmap_id,
			status=RoadmapStepProgress.Status.COMPLETED,
		).count()
		percent = int((completed_steps / total_steps) * 100) if total_steps else 0

		return success_response(
			{
				"step_id": str(step.id),
				"status": progress.status,
				"completed_at": progress.completed_at,
				"roadmap_completion_percent": percent,
			}
		)


class RoadmapProgressSummaryView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		roadmaps = Roadmap.objects.filter(user=request.user, is_active=True).select_related(
			"career"
		)
		total_steps = RoadmapStep.objects.filter(roadmap__in=roadmaps).count()
		completed_steps = RoadmapStepProgress.objects.filter(
			user=request.user,
			roadmap_step__roadmap__in=roadmaps,
			status=RoadmapStepProgress.Status.COMPLETED,
		).count()

		roadmaps_data = []
		for roadmap in roadmaps:
			steps = RoadmapStep.objects.filter(roadmap=roadmap)
			completed = RoadmapStepProgress.objects.filter(
				user=request.user,
				roadmap_step__roadmap=roadmap,
				status=RoadmapStepProgress.Status.COMPLETED,
			).count()
			total = steps.count()
			next_step = steps.order_by("step_order").first()
			roadmaps_data.append(
				{
					"id": str(roadmap.id),
					"career_name": roadmap.career.name,
					"total_steps": total,
					"completed_steps": completed,
					"completion_percent": int((completed / total) * 100) if total else 0,
					"next_step": {
						"id": str(next_step.id) if next_step else None,
						"title": next_step.title if next_step else None,
						"category": next_step.category if next_step else None,
						"timeframe": next_step.timeframe if next_step else None,
					},
				}
			)

		profile = InterestProfile.objects.filter(user=request.user, is_active=True).first()
		data = {
			"active_roadmaps": roadmaps.count(),
			"total_steps_across_all": total_steps,
			"completed_steps": completed_steps,
			"overall_completion_percent": int((completed_steps / total_steps) * 100)
			if total_steps
			else 0,
			"roadmaps": roadmaps_data,
			"interest_profile_summary": {
				"top_dimensions": profile.top_dimensions if profile else [],
				"dimension_scores": profile.dimension_scores if profile else {},
			},
			"top_3_matched_careers": [roadmap.career.slug for roadmap in roadmaps[:3]],
		}
		return success_response(data)
