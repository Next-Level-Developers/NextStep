from rest_framework import serializers

from apps.careers.models import Career, CareerCluster, CareerDomain
from apps.recommendations.models import CareerRecommendation, CareerSave


def format_lpa(min_paise, max_paise):
	if min_paise is None or max_paise is None:
		return None
	min_lpa = int(min_paise / 10000000)
	max_lpa = int(max_paise / 10000000)
	return f"{min_lpa}-{max_lpa}"


class CareerDomainSerializer(serializers.ModelSerializer):
	class Meta:
		model = CareerDomain
		fields = [
			"id",
			"slug",
			"name",
			"short_name",
			"india_relevance",
			"growth_forecast_2035",
			"entry_path_summary",
			"display_order",
		]


class CareerListSerializer(serializers.ModelSerializer):
	domain = CareerDomainSerializer(read_only=True)
	salary_entry_lpa = serializers.SerializerMethodField()
	salary_mid_lpa = serializers.SerializerMethodField()
	salary_senior_lpa = serializers.SerializerMethodField()

	class Meta:
		model = Career
		fields = [
			"id",
			"slug",
			"name",
			"one_liner",
			"domain",
			"dimension_tags",
			"india_viability",
			"future_score",
			"is_emerging",
			"salary_entry_lpa",
			"salary_mid_lpa",
			"salary_senior_lpa",
		]

	def get_salary_entry_lpa(self, obj):
		return format_lpa(obj.salary_entry_min_paise, obj.salary_entry_max_paise)

	def get_salary_mid_lpa(self, obj):
		return format_lpa(obj.salary_mid_min_paise, obj.salary_mid_max_paise)

	def get_salary_senior_lpa(self, obj):
		return format_lpa(obj.salary_senior_min_paise, obj.salary_senior_max_paise)


class CareerDetailSerializer(serializers.ModelSerializer):
	domain = CareerDomainSerializer(read_only=True)
	salary_entry_lpa = serializers.SerializerMethodField()
	salary_mid_lpa = serializers.SerializerMethodField()
	salary_senior_lpa = serializers.SerializerMethodField()
	related_careers = serializers.SerializerMethodField()
	is_saved = serializers.SerializerMethodField()
	user_match_score = serializers.SerializerMethodField()

	class Meta:
		model = Career
		fields = [
			"id",
			"slug",
			"name",
			"one_liner",
			"domain",
			"dimension_tags",
			"india_viability",
			"future_score",
			"future_score_reasoning",
			"typical_day",
			"skills_needed",
			"entry_paths",
			"salary_entry_min_paise",
			"salary_entry_max_paise",
			"salary_mid_min_paise",
			"salary_mid_max_paise",
			"salary_senior_min_paise",
			"salary_senior_max_paise",
			"salary_entry_lpa",
			"salary_mid_lpa",
			"salary_senior_lpa",
			"is_emerging",
			"last_reviewed_at",
			"related_careers",
			"is_saved",
			"user_match_score",
		]

	def get_salary_entry_lpa(self, obj):
		return format_lpa(obj.salary_entry_min_paise, obj.salary_entry_max_paise)

	def get_salary_mid_lpa(self, obj):
		return format_lpa(obj.salary_mid_min_paise, obj.salary_mid_max_paise)

	def get_salary_senior_lpa(self, obj):
		return format_lpa(obj.salary_senior_min_paise, obj.salary_senior_max_paise)

	def get_related_careers(self, obj):
		if not obj.related_career_ids:
			return []
		careers = Career.objects.filter(id__in=obj.related_career_ids)
		return [
			{
				"slug": career.slug,
				"name": career.name,
				"one_liner": career.one_liner,
				"future_score": career.future_score,
			}
			for career in careers
		]

	def get_is_saved(self, obj):
		request = self.context.get("request")
		if not request or not request.user.is_authenticated:
			return False
		return CareerSave.objects.filter(user=request.user, career=obj).exists()

	def get_user_match_score(self, obj):
		request = self.context.get("request")
		if not request or not request.user.is_authenticated:
			return None
		rec = CareerRecommendation.objects.filter(user=request.user, career=obj).first()
		return rec.match_score if rec else None


class CareerClusterSerializer(serializers.ModelSerializer):
	class Meta:
		model = CareerCluster
		fields = ["id", "name", "q24_description"]
