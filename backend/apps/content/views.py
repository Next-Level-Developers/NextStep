from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView

from apps.careers.models import Career
from apps.content.models import LearningResource, RealPeopleStory
from apps.content.serializers import LearningResourceSerializer, RealPeopleStorySerializer
from utils.responses import error_response, success_response


class CareerStoriesView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request, slug):
		career = Career.objects.filter(slug=slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)

		stories = RealPeopleStory.objects.filter(career=career, is_active=True)
		is_premium = request.user.subscription_tier != "free"

		data = {
			"career_slug": career.slug,
			"stories": [],
		}

		for index, story in enumerate(stories):
			serialized = RealPeopleStorySerializer(story).data
			if not is_premium and index > 0:
				serialized["locked"] = True
				serialized["story_text"] = None
			data["stories"].append(serialized)

		return success_response(data)


class CareerResourcesView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request, slug):
		career = Career.objects.filter(slug=slug).first()
		if not career:
			return error_response(
				"CAREER_NOT_FOUND",
				"Career slug doesn't exist.",
				status=status.HTTP_404_NOT_FOUND,
			)
		resources = LearningResource.objects.filter(is_active=True)
		data = {
			"career_slug": career.slug,
			"resources": LearningResourceSerializer(resources, many=True).data,
		}
		return success_response(data)
