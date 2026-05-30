from django.db.models import Q
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from apps.careers.models import Career, CareerCluster, CareerDomain
from apps.careers.serializers import (
	CareerClusterSerializer,
	CareerDetailSerializer,
	CareerDomainSerializer,
	CareerListSerializer,
)
from apps.recommendations.models import CareerSave, CareerView
from utils.responses import error_response, success_response


class CareerListView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		queryset = Career.objects.select_related("domain").filter(is_active=True)

		search = request.query_params.get("search")
		if search:
			queryset = queryset.filter(
				Q(name__icontains=search)
				| Q(one_liner__icontains=search)
				| Q(skills_needed__overlap=[search])
			)

		domain_slug = request.query_params.get("domain_slug")
		if domain_slug:
			queryset = queryset.filter(domain__slug=domain_slug)

		dimension_tags = request.query_params.get("dimension_tags")
		if dimension_tags:
			tags = [tag.strip() for tag in dimension_tags.split(",") if tag.strip()]
			if tags:
				queryset = queryset.filter(dimension_tags__overlap=tags)

		india_viability = request.query_params.get("india_viability")
		if india_viability:
			queryset = queryset.filter(india_viability=india_viability)

		future_score_min = request.query_params.get("future_score_min")
		if future_score_min:
			queryset = queryset.filter(future_score__gte=int(future_score_min))

		is_emerging = request.query_params.get("is_emerging")
		if is_emerging in {"true", "false"}:
			queryset = queryset.filter(is_emerging=is_emerging == "true")

		ordering = request.query_params.get("ordering")
		if ordering:
			queryset = queryset.order_by(ordering)

		page_size = int(request.query_params.get("page_size", 20))
		page = int(request.query_params.get("page", 1))
		start = (page - 1) * page_size
		end = start + page_size
		total = queryset.count()
		results = queryset[start:end]

		data = {
			"count": total,
			"next": None,
			"previous": None,
			"results": CareerListSerializer(results, many=True).data,
		}
		return success_response(data)


class CareerDetailView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request, slug):
		career = Career.objects.select_related("domain").filter(slug=slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)
		serializer = CareerDetailSerializer(career, context={"request": request})
		return success_response(serializer.data)


class CareerDomainsView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		domains = CareerDomain.objects.filter(is_active=True).order_by("display_order")
		data = CareerDomainSerializer(domains, many=True).data
		return success_response(data)


class CareerDomainDetailView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request, slug):
		domain = CareerDomain.objects.filter(slug=slug).first()
		if not domain:
			return error_response(
				"DOMAIN_NOT_FOUND",
				"Career domain not found.",
				status=status.HTTP_404_NOT_FOUND,
			)
		careers = Career.objects.filter(domain=domain, is_active=True)
		data = CareerDomainSerializer(domain).data
		data["careers"] = CareerListSerializer(careers, many=True).data
		return success_response(data)


class CareerClustersView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		clusters = CareerCluster.objects.all()
		data = CareerClusterSerializer(clusters, many=True).data
		return success_response(data)


class CareerCompareView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		slugs = request.query_params.get("slugs")
		if not slugs:
			return error_response(
				"VALIDATION_ERROR",
				"Slugs parameter is required.",
				status=status.HTTP_400_BAD_REQUEST,
			)
		slug_list = [slug.strip() for slug in slugs.split(",") if slug.strip()]
		if len(slug_list) < 2 or len(slug_list) > 3:
			return error_response(
				"VALIDATION_ERROR",
				"Provide 2 or 3 career slugs.",
				status=status.HTTP_400_BAD_REQUEST,
			)

		careers = Career.objects.filter(slug__in=slug_list)
		data = {
			"careers": [
				{
					"slug": career.slug,
					"name": career.name,
					"dimension_tags": career.dimension_tags,
					"future_score": career.future_score,
					"india_viability": career.india_viability,
					"salary_entry_lpa": None,
					"salary_mid_lpa": None,
					"salary_senior_lpa": None,
					"user_skill_overlap_count": 0,
					"user_skill_overlap": [],
					"work_style": "desk_collaborative",
					"time_to_first_job_months": 24,
					"entry_difficulty": "medium",
				}
				for career in careers
			],
			"comparison_dimensions": [
				"salary",
				"future_score",
				"skill_overlap",
				"entry_difficulty",
				"india_viability",
			],
		}
		return success_response(data)


class CareerSaveView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request, slug):
		career = Career.objects.filter(slug=slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)
		existing = CareerSave.objects.filter(user=request.user, career=career).first()
		if existing:
			return error_response(
				"ALREADY_SAVED",
				"Career already bookmarked.",
				status=status.HTTP_409_CONFLICT,
			)
		save = CareerSave.objects.create(
			user=request.user, career=career, notes=request.data.get("notes")
		)
		return success_response(
			{
				"save_id": str(save.id),
				"career_slug": career.slug,
				"saved_at": save.saved_at,
			},
			status=status.HTTP_201_CREATED,
		)

	def delete(self, request, slug):
		career = Career.objects.filter(slug=slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)
		CareerSave.objects.filter(user=request.user, career=career).delete()
		return Response(status=status.HTTP_204_NO_CONTENT)

	def patch(self, request, slug):
		career = Career.objects.filter(slug=slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)
		save = CareerSave.objects.filter(user=request.user, career=career).first()
		if not save:
			return error_response(
				"ALREADY_SAVED",
				"Career already bookmarked.",
				status=status.HTTP_409_CONFLICT,
			)
		save.notes = request.data.get("notes", save.notes)
		save.save(update_fields=["notes"])
		return success_response({"save_id": str(save.id), "notes": save.notes})


class CareerViewTrackView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request, slug):
		career = Career.objects.filter(slug=slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)
		view = CareerView.objects.create(
			user=request.user,
			career=career,
			source=request.data.get("source", ""),
			time_spent_seconds=request.data.get("time_spent_seconds"),
			reached_roadmap=bool(request.data.get("reached_roadmap", False)),
		)
		return success_response({"view_id": str(view.id)}, status=status.HTTP_201_CREATED)
