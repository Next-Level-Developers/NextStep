from django.db import transaction
from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from apps.profiler.models import InterestProfile, ProfilerResponse, ProfilerSession
from apps.profiler.question_bank import (
	compute_dimension_weights,
	get_question_map,
	get_total_questions,
	load_questions,
)
from apps.profiler.scoring_engine import compute_dimension_scores
from apps.profiler.serializers import InterestProfileSerializer, ProfilerSessionSerializer
from apps.users.models import StudentProfile
from utils.responses import error_response, success_response


class QuestionsView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		return success_response(load_questions())


class SessionCreateView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request):
		question_total = get_total_questions()
		if not question_total:
			return error_response(
				"PROFILER_NOT_CONFIGURED",
				"Profiler question bank is empty.",
				status=status.HTTP_500_INTERNAL_SERVER_ERROR,
			)
		session_number = (
			ProfilerSession.objects.filter(user=request.user).count() + 1
		)
		session = ProfilerSession.objects.create(
			user=request.user,
			session_number=session_number,
			total_questions=question_total,
		)
		data = {
			"session_id": str(session.id),
			"session_number": session.session_number,
			"status": session.status,
			"total_questions": session.total_questions,
			"questions_answered": session.questions_answered,
			"started_at": session.started_at,
		}
		return success_response(data, status=status.HTTP_201_CREATED)


class SessionDetailView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request, session_id):
		session = ProfilerSession.objects.filter(id=session_id, user=request.user).first()
		if not session:
			return error_response(
				"PROFILER_SESSION_NOT_FOUND",
				"No active profiler session found for this user.",
				status=status.HTTP_404_NOT_FOUND,
			)

		last_response = session.responses.order_by("-answered_at").first()
		data = {
			"session_id": str(session.id),
			"session_number": session.session_number,
			"status": session.status,
			"total_questions": session.total_questions,
			"questions_answered": session.questions_answered,
			"questions_skipped": session.questions_skipped,
			"last_answered_code": last_response.question_code if last_response else None,
			"started_at": session.started_at,
		}
		return success_response(data)


class SessionResponsesView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request, session_id):
		session = ProfilerSession.objects.filter(id=session_id, user=request.user).first()
		if not session:
			return error_response(
				"PROFILER_SESSION_NOT_FOUND",
				"No active profiler session found for this user.",
				status=status.HTTP_404_NOT_FOUND,
			)

		if session.status == ProfilerSession.Status.COMPLETED:
			return error_response(
				"PROFILER_SESSION_COMPLETED",
				"This profiler session is already completed.",
				status=status.HTTP_409_CONFLICT,
			)

		responses = request.data.get("responses", [])
		if not isinstance(responses, list) or not responses:
			return error_response(
				"VALIDATION_ERROR",
				"Responses must be a non-empty list.",
				status=status.HTTP_400_BAD_REQUEST,
			)

		question_map = get_question_map()
		if not question_map:
			return error_response(
				"PROFILER_NOT_CONFIGURED",
				"Profiler question bank is empty.",
				status=status.HTTP_500_INTERNAL_SERVER_ERROR,
			)

		with transaction.atomic():
			for response in responses:
				question_code = response.get("question_code")
				question = question_map.get(question_code)
				if not question:
					return error_response(
						"VALIDATION_ERROR",
						f"Unknown question code: {question_code}.",
						status=status.HTTP_400_BAD_REQUEST,
					)

				if ProfilerResponse.objects.filter(
					session=session, question_code=question_code
				).exists():
					return error_response(
						"VALIDATION_ERROR",
						f"Question {question_code} already answered.",
						status=status.HTTP_409_CONFLICT,
					)

				selected_indices = response.get("selected_option_index", [])
				if not isinstance(selected_indices, list):
					return error_response(
						"VALIDATION_ERROR",
						"selected_option_index must be a list.",
						status=status.HTTP_400_BAD_REQUEST,
					)

				is_skipped = bool(response.get("skipped"))
				if is_skipped and not question.get("is_skippable", True):
					return error_response(
						"VALIDATION_ERROR",
						f"Question {question_code} cannot be skipped.",
						status=status.HTTP_400_BAD_REQUEST,
					)

				if not is_skipped:
					question_type = question.get("question_type")
					if question_type == "single_select" and len(selected_indices) != 1:
						return error_response(
							"VALIDATION_ERROR",
							f"Question {question_code} requires 1 selection.",
							status=status.HTTP_400_BAD_REQUEST,
						)
					if question_type == "multi_select":
						max_sel = question.get("max_selections")
						if max_sel and len(selected_indices) > int(max_sel):
							return error_response(
								"VALIDATION_ERROR",
								f"Question {question_code} allows up to {max_sel} selections.",
								status=status.HTTP_400_BAD_REQUEST,
							)

					option_indices = {option.get("index") for option in question.get("options", [])}
					if any(index not in option_indices for index in selected_indices):
						return error_response(
							"VALIDATION_ERROR",
							f"Question {question_code} has invalid option index.",
							status=status.HTTP_400_BAD_REQUEST,
						)
				else:
					selected_indices = []

				dimension_weights = compute_dimension_weights(question, selected_indices)

				ProfilerResponse.objects.create(
					session=session,
					question_code=question_code,
					question_section=question.get("section"),
					selected_option_index=selected_indices,
					dimension_weights=dimension_weights,
					skipped=is_skipped,
				)

			answered = ProfilerResponse.objects.filter(session=session).count()
			skipped = ProfilerResponse.objects.filter(session=session, skipped=True).count()
			session.questions_answered = answered
			session.questions_skipped = skipped
			session.save(update_fields=["questions_answered", "questions_skipped"])

		progress_percent = int((session.questions_answered / session.total_questions) * 100)
		data = {
			"session_id": str(session.id),
			"questions_answered": session.questions_answered,
			"questions_skipped": session.questions_skipped,
			"progress_percent": progress_percent,
		}
		return success_response(data)


class SessionCompleteView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request, session_id):
		session = ProfilerSession.objects.filter(id=session_id, user=request.user).first()
		if not session:
			return error_response(
				"PROFILER_SESSION_NOT_FOUND",
				"No active profiler session found for this user.",
				status=status.HTTP_404_NOT_FOUND,
			)

		if session.status == ProfilerSession.Status.COMPLETED:
			profile = getattr(session, "interest_profile", None)
		else:
			question_map = get_question_map()
			if not question_map:
				return error_response(
					"PROFILER_NOT_CONFIGURED",
					"Profiler question bank is empty.",
					status=status.HTTP_500_INTERNAL_SERVER_ERROR,
				)

			answered_codes = set(
				ProfilerResponse.objects.filter(session=session).values_list(
					"question_code", flat=True
				)
			)
			missing_required = [
				code
				for code, question in question_map.items()
				if not question.get("is_skippable", True) and code not in answered_codes
			]
			if missing_required:
				return error_response(
					"VALIDATION_ERROR",
					"Required questions are not answered.",
					{"missing_questions": missing_required},
					status=status.HTTP_400_BAD_REQUEST,
				)

			if len(answered_codes) < len(question_map):
				return error_response(
					"VALIDATION_ERROR",
					"All questions must be answered or skipped.",
					status=status.HTTP_400_BAD_REQUEST,
				)
			dimension_scores = compute_dimension_scores(session.id)
			top_dimensions = sorted(
				dimension_scores.keys(), key=lambda k: dimension_scores[k], reverse=True
			)[:3]

			InterestProfile.objects.filter(user=request.user, is_active=True).update(
				is_active=False
			)
			profile = InterestProfile.objects.create(
				user=request.user,
				session=session,
				is_active=True,
				dimension_scores=dimension_scores,
				top_dimensions=top_dimensions,
				career_cluster_weights={},
				awareness_known_careers=[],
			)
			session.status = ProfilerSession.Status.COMPLETED
			session.completed_at = timezone.now()
			session.save(update_fields=["status", "completed_at"])

			StudentProfile.objects.filter(user=request.user).update(
				profiler_completed=True, profiler_completed_at=timezone.now()
			)

		data = {
			"session_id": str(session.id),
			"status": session.status,
			"time_taken_seconds": session.time_taken_seconds,
			"interest_profile": InterestProfileSerializer(profile).data,
			"recommendations_ready": False,
			"recommendations_eta_seconds": 3,
		}
		return success_response(data)


class ActiveProfileView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		profile = InterestProfile.objects.filter(user=request.user, is_active=True).first()
		if not profile:
			return error_response(
				"PROFILER_NOT_COMPLETED",
				"Complete the interest profiler to see your career matches.",
				status=status.HTTP_404_NOT_FOUND,
			)
		return success_response(InterestProfileSerializer(profile).data)
