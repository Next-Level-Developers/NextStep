import os

from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView

from apps.subscriptions.models import SubscriptionPlan, SubscriptionTransaction
from apps.subscriptions.razorpay_service import verify_signature
from apps.subscriptions.serializers import SubscriptionPlanSerializer
from utils.dates import expires_at_from_days
from utils.responses import error_response, success_response


class PlansListView(APIView):
	permission_classes = [AllowAny]

	def get(self, request):
		plans = SubscriptionPlan.objects.all()
		data = SubscriptionPlanSerializer(plans, many=True).data
		return success_response(data)


class CreateOrderView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request):
		plan_id = request.data.get("plan_id")
		plan = SubscriptionPlan.objects.filter(id=plan_id).first()
		if not plan:
			return error_response(
				"PLAN_NOT_FOUND",
				"Subscription plan not found.",
				status=status.HTTP_404_NOT_FOUND,
			)

		transaction = SubscriptionTransaction.objects.create(
			user=request.user,
			plan=plan,
			amount_paise=plan.price_paise,
			status=SubscriptionTransaction.Status.PENDING,
		)
		razorpay_order_id = f"order_{transaction.id}"
		transaction.razorpay_order_id = razorpay_order_id
		transaction.save(update_fields=["razorpay_order_id"])

		data = {
			"transaction_id": str(transaction.id),
			"razorpay_order_id": razorpay_order_id,
			"amount_paise": transaction.amount_paise,
			"currency": "INR",
			"razorpay_key_id": os.environ.get("RAZORPAY_KEY_ID", ""),
		}
		return success_response(data, status=status.HTTP_201_CREATED)


class VerifyPaymentView(APIView):
	permission_classes = [IsAuthenticated]

	def post(self, request):
		transaction_id = request.data.get("transaction_id")
		order_id = request.data.get("razorpay_order_id")
		payment_id = request.data.get("razorpay_payment_id")
		signature = request.data.get("razorpay_signature")

		transaction = SubscriptionTransaction.objects.filter(id=transaction_id).first()
		if not transaction:
			return error_response(
				"TRANSACTION_NOT_FOUND",
				"Transaction not found.",
				status=status.HTTP_404_NOT_FOUND,
			)

		if not verify_signature(order_id, payment_id, signature):
			transaction.status = SubscriptionTransaction.Status.FAILED
			transaction.save(update_fields=["status"])
			return error_response(
				"PAYMENT_SIGNATURE_INVALID",
				"Payment verification failed. Please contact support.",
				status=status.HTTP_400_BAD_REQUEST,
			)

		transaction.status = SubscriptionTransaction.Status.SUCCESS
		transaction.razorpay_payment_id = payment_id
		transaction.save(update_fields=["status", "razorpay_payment_id"])

		request.user.subscription_tier = transaction.plan.name
		if transaction.plan.duration_days:
			request.user.subscription_expires_at = expires_at_from_days(
				transaction.plan.duration_days
			)
		request.user.save(update_fields=["subscription_tier", "subscription_expires_at"])

		data = {
			"subscription_tier": request.user.subscription_tier,
			"subscription_expires_at": request.user.subscription_expires_at,
			"transaction_id": str(transaction.id),
			"payment_id": payment_id,
		}
		return success_response(data)


class SubscriptionMeView(APIView):
	permission_classes = [IsAuthenticated]

	def get(self, request):
		plan = SubscriptionPlan.objects.filter(name=request.user.subscription_tier).first()
		data = {
			"subscription_tier": request.user.subscription_tier,
			"subscription_expires_at": request.user.subscription_expires_at,
			"days_remaining": None,
			"is_active": request.user.subscription_tier != "free",
			"plan": {
				"name": plan.name if plan else request.user.subscription_tier,
				"display_name": plan.name.replace("_", " ").title() if plan else None,
				"price_inr": int(plan.price_paise / 100) if plan else None,
			},
		}
		return success_response(data)
