import uuid
from datetime import timedelta

from django.contrib.auth import get_user_model
from django.core.signing import BadSignature, SignatureExpired, TimestampSigner
from django.db.models import Avg, Count
from django.utils import timezone
from rest_framework import permissions, status
from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken

from apps.careers.models import Career
from apps.recommendations.models import CareerRecommendation
from apps.users.firebase_backend import verify_firebase_token
from apps.users.models import SchoolMembership, StudentProfile
from apps.users.permissions import IsCounsellor, IsStudent
from apps.users.serializers import (
	AvatarUploadSerializer,
	FirebaseAuthSerializer,
	ParentalConsentSerializer,
	ShareTokenSerializer,
	StudentProfileSerializer,
	UserSerializer,
	UserUpdateSerializer,
)
from apps.users.models import SchoolOrganisation
from apps.profiler.models import InterestProfile
from utils.responses import error_response, success_response

User = get_user_model()


class FirebaseAuthView(APIView):
	permission_classes = [permissions.AllowAny]

	def post(self, request):
		serializer = FirebaseAuthSerializer(data=request.data)
		serializer.is_valid(raise_exception=True)

		try:
			decoded = verify_firebase_token(serializer.validated_data["firebase_token"])
		except Exception:
			return error_response(
				"INVALID_FIREBASE_TOKEN",
				"Firebase token verification failed.",
				status=status.HTTP_401_UNAUTHORIZED,
			)

		firebase_uid = decoded.get("uid")
		email = decoded.get("email")
		if not firebase_uid or not email:
			return error_response(
				"INVALID_FIREBASE_TOKEN",
				"Firebase token is missing uid or email.",
				status=status.HTTP_401_UNAUTHORIZED,
			)

		user, created = User.objects.get_or_create(
			firebase_uid=firebase_uid,
			defaults={
				"email": email,
				"user_type": User.UserType.STUDENT,
				"subscription_tier": User.SubscriptionTier.FREE,
			},
		)

		if not created and user.email != email:
			user.email = email
			user.save(update_fields=["email"])

		refresh = RefreshToken.for_user(user)
		response_data = {
			"access": str(refresh.access_token),
			"refresh": str(refresh),
			"is_new_user": created,
			"user": {
				"id": str(user.id),
				"email": user.email,
				"user_type": user.user_type,
				"subscription_tier": user.subscription_tier,
				"profiler_completed": getattr(user.student_profile, "profiler_completed", False),
			},
		}
		return success_response(response_data, status=status.HTTP_201_CREATED)


class MeView(APIView):
	def get(self, request):
		return success_response(UserSerializer(request.user).data)

	def patch(self, request):
		serializer = UserUpdateSerializer(instance=request.user, data=request.data, partial=True)
		serializer.is_valid(raise_exception=True)
		serializer.save()
		return success_response(UserSerializer(request.user).data)

	def delete(self, request):
		request.user.is_active = False
		request.user.save(update_fields=["is_active"])
		return Response(status=status.HTTP_204_NO_CONTENT)


class AvatarUploadView(APIView):
	parser_classes = [MultiPartParser, FormParser]

	def post(self, request):
		serializer = AvatarUploadSerializer(data=request.data)
		serializer.is_valid(raise_exception=True)

		file_obj = serializer.validated_data["file"]
		extension = file_obj.name.split(".")[-1].lower()
		avatar_key = f"avatars/{uuid.uuid4()}.{extension}"
		avatar_url = f"https://nextstep-assets.s3.amazonaws.com/{avatar_key}"

		request.user.avatar_url = avatar_url
		request.user.save(update_fields=["avatar_url"])
		return success_response({"avatar_url": avatar_url})


class StudentProfileView(APIView):
	permission_classes = [IsStudent]

	def get(self, request):
		if not hasattr(request.user, "student_profile"):
			return error_response(
				"STUDENT_PROFILE_NOT_FOUND",
				"Student profile not found.",
				status=status.HTTP_404_NOT_FOUND,
			)
		return success_response(StudentProfileSerializer(request.user.student_profile).data)

	def put(self, request):
		profile = getattr(request.user, "student_profile", None)
		serializer = StudentProfileSerializer(instance=profile, data=request.data)
		serializer.is_valid(raise_exception=True)
		serializer.save(user=request.user)
		return success_response(serializer.data)


class ParentalConsentView(APIView):
	def post(self, request):
		serializer = ParentalConsentSerializer(data=request.data)
		serializer.is_valid(raise_exception=True)

		consent_given = serializer.validated_data["consent_given"]
		request.user.parental_consent_given = consent_given
		request.user.parental_consent_at = timezone.now() if consent_given else None
		request.user.save(update_fields=["parental_consent_given", "parental_consent_at"])
		return success_response(
			{
				"parental_consent_given": request.user.parental_consent_given,
				"parental_consent_at": request.user.parental_consent_at,
			}
		)


class ShareTokenView(APIView):
	def post(self, request):
		signer = TimestampSigner()
		share_token = signer.sign(str(request.user.id))
		expires_at = timezone.now() + timedelta(days=30)
		share_url = f"https://app.nextstep.app/parent-view/{share_token}"
		serializer = ShareTokenSerializer(
			{"share_token": share_token, "share_url": share_url, "expires_at": expires_at}
		)
		return success_response(serializer.data, status=status.HTTP_201_CREATED)


class ParentShareProfileView(APIView):
	permission_classes = [permissions.AllowAny]

	def get(self, request, share_token):
		signer = TimestampSigner()
		try:
			user_id = signer.unsign(share_token, max_age=60 * 60 * 24 * 30)
		except SignatureExpired:
			return error_response(
				"SHARE_TOKEN_INVALID",
				"Share token expired or invalid.",
				status=status.HTTP_404_NOT_FOUND,
			)
		except BadSignature:
			return error_response(
				"SHARE_TOKEN_INVALID",
				"Share token expired or invalid.",
				status=status.HTTP_404_NOT_FOUND,
			)

		user = User.objects.filter(id=user_id, is_active=True).first()
		if not user:
			return error_response(
				"SHARE_TOKEN_INVALID",
				"Share token expired or invalid.",
				status=status.HTTP_404_NOT_FOUND,
			)

		interest_profile = (
			InterestProfile.objects.filter(user=user, is_active=True).first()
		)
		recommendations = (
			CareerRecommendation.objects.filter(user=user)
			.select_related("career")
			.order_by("display_rank")[:3]
		)
		top_careers = [
			{
				"rank": rec.display_rank,
				"career_name": rec.career.name,
				"one_liner": rec.career.one_liner,
				"salary_entry_lpa": None,
				"salary_senior_lpa": None,
				"future_score": rec.career.future_score,
			}
			for rec in recommendations
		]

		student_profile = getattr(user, "student_profile", None)
		data = {
			"student_first_name": (user.full_name or user.email).split(" ")[0],
			"academic_stage": getattr(student_profile, "academic_stage", None),
			"profiler_completed": getattr(student_profile, "profiler_completed", False),
			"top_matched_careers": top_careers,
			"roadmap_summary": {
				"career_name": top_careers[0]["career_name"] if top_careers else None,
				"immediate_actions": [],
			},
			"counsellor_cta": {
				"text": "Want to discuss this with a counsellor?",
				"url": "https://nextstep.app/counsellors",
			},
		}
		return success_response(data)


class CounsellorDashboardView(APIView):
	permission_classes = [IsCounsellor]

	def get(self, request):
		membership = (
			SchoolMembership.objects.filter(user=request.user)
			.select_related("organisation")
			.first()
		)
		organisation = membership.organisation if membership else None

		if not organisation:
			return error_response(
				"PERMISSION_DENIED",
				"Counsellor is not linked to a school organisation.",
				status=status.HTTP_403_FORBIDDEN,
			)

		student_memberships = SchoolMembership.objects.filter(
			organisation=organisation, role=SchoolMembership.Role.STUDENT
		)
		student_ids = student_memberships.values_list("user_id", flat=True)

		students_total = student_memberships.count()
		students_profiler_completed = StudentProfile.objects.filter(
			user_id__in=student_ids, profiler_completed=True
		).count()

		top_career_interests = (
			CareerRecommendation.objects.filter(user_id__in=student_ids)
			.values("career__slug", "career__name")
			.annotate(student_count=Count("user_id", distinct=True))
			.order_by("-student_count")[:3]
		)
		top_career_interests_data = [
			{
				"career_slug": row["career__slug"],
				"career_name": row["career__name"],
				"student_count": row["student_count"],
			}
			for row in top_career_interests
		]

		top_domains = (
			CareerRecommendation.objects.filter(user_id__in=student_ids)
			.values("career__domain__short_name")
			.annotate(student_count=Count("user_id", distinct=True))
			.order_by("-student_count")[:3]
		)
		top_domains_data = [
			{
				"domain_short_name": row["career__domain__short_name"],
				"student_count": row["student_count"],
			}
			for row in top_domains
		]

		dimension_distribution = {"C": 0, "A": 0, "T": 0, "S": 0, "E": 0, "P": 0}
		profiles = InterestProfile.objects.filter(user_id__in=student_ids, is_active=True)
		if profiles.exists():
			sums = {"C": 0, "A": 0, "T": 0, "S": 0, "E": 0, "P": 0}
			for profile in profiles:
				for key in sums:
					sums[key] += profile.dimension_scores.get(key, 0)
			count = profiles.count()
			dimension_distribution = {key: int(sums[key] / count) for key in sums}

		data = {
			"organisation": {
				"id": str(organisation.id),
				"name": organisation.name,
				"type": organisation.type,
				"licence_seats": organisation.licence_seats,
			},
			"students_total": students_total,
			"students_profiler_completed": students_profiler_completed,
			"profiler_completion_rate_percent": int(
				(students_profiler_completed / students_total) * 100
			)
			if students_total
			else 0,
			"top_career_interests": top_career_interests_data,
			"top_domains": top_domains_data,
			"dimension_distribution": dimension_distribution,
		}
		return success_response(data)


class CounsellorStudentsView(APIView):
	permission_classes = [IsCounsellor]

	def get(self, request):
		membership = (
			SchoolMembership.objects.filter(user=request.user)
			.select_related("organisation")
			.first()
		)
		organisation = membership.organisation if membership else None

		if not organisation:
			return error_response(
				"PERMISSION_DENIED",
				"Counsellor is not linked to a school organisation.",
				status=status.HTTP_403_FORBIDDEN,
			)

		student_memberships = SchoolMembership.objects.filter(
			organisation=organisation, role=SchoolMembership.Role.STUDENT
		)
		student_ids = list(student_memberships.values_list("user_id", flat=True))
		student_profiles = StudentProfile.objects.filter(user_id__in=student_ids)

		academic_stage = request.query_params.get("academic_stage")
		if academic_stage:
			student_profiles = student_profiles.filter(academic_stage=academic_stage)

		profiler_completed = request.query_params.get("profiler_completed")
		if profiler_completed in {"true", "false"}:
			student_profiles = student_profiles.filter(
				profiler_completed=profiler_completed == "true"
			)

		results = []
		for index, profile in enumerate(student_profiles, start=1):
			top_matches = (
				CareerRecommendation.objects.filter(user=profile.user)
				.select_related("career")
				.order_by("display_rank")[:3]
			)
			results.append(
				{
					"student_id": str(profile.user_id),
					"display_name": f"Student #{index}",
					"academic_stage": profile.academic_stage,
					"profiler_completed": profile.profiler_completed,
					"top_matched_careers": [rec.career.name for rec in top_matches],
					"roadmaps_active": profile.user.roadmaps.filter(is_active=True).count(),
					"last_active_at": None,
				}
			)

		return success_response({"count": len(results), "results": results})
