from rest_framework import serializers

from apps.subscriptions.models import SubscriptionPlan, SubscriptionTransaction


class SubscriptionPlanSerializer(serializers.ModelSerializer):
	display_name = serializers.SerializerMethodField()
	price_inr = serializers.SerializerMethodField()

	class Meta:
		model = SubscriptionPlan
		fields = [
			"id",
			"name",
			"display_name",
			"price_paise",
			"price_inr",
			"duration_days",
			"features",
		]

	def get_display_name(self, obj):
		return obj.name.replace("_", " ").title()

	def get_price_inr(self, obj):
		return int(obj.price_paise / 100)


class SubscriptionTransactionSerializer(serializers.ModelSerializer):
	class Meta:
		model = SubscriptionTransaction
		fields = [
			"id",
			"plan_id",
			"razorpay_order_id",
			"razorpay_payment_id",
			"amount_paise",
			"status",
			"created_at",
		]
