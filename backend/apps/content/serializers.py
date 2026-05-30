from rest_framework import serializers

from apps.content.models import LearningResource, RealPeopleStory


class RealPeopleStorySerializer(serializers.ModelSerializer):
	class Meta:
		model = RealPeopleStory
		fields = [
			"id",
			"person_name",
			"person_age",
			"person_city",
			"person_background",
			"story_text",
			"is_premium",
		]


class LearningResourceSerializer(serializers.ModelSerializer):
	class Meta:
		model = LearningResource
		fields = [
			"id",
			"title",
			"url",
			"provider",
			"resource_type",
			"is_free",
		]
