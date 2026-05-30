import uuid

from django.conf import settings
from django.db import models


class SubscriptionPlan(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=50, unique=True)
    price_paise = models.IntegerField()
    duration_days = models.IntegerField(blank=True, null=True)
    features = models.JSONField()

    class Meta:
        db_table = "subscription_plans"

    def __str__(self):
        return self.name


class SubscriptionTransaction(models.Model):
    class Status(models.TextChoices):
        PENDING = "pending", "pending"
        SUCCESS = "success", "success"
        FAILED = "failed", "failed"
        REFUNDED = "refunded", "refunded"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="subscription_transactions",
    )
    plan = models.ForeignKey(
        "subscriptions.SubscriptionPlan",
        on_delete=models.CASCADE,
        related_name="transactions",
    )
    razorpay_order_id = models.CharField(max_length=200, blank=True, null=True, unique=True)
    razorpay_payment_id = models.CharField(max_length=200, blank=True, null=True)
    amount_paise = models.IntegerField()
    status = models.CharField(max_length=20, choices=Status.choices)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "subscription_transactions"

    def __str__(self):
        return f"SubscriptionTransaction({self.user_id}, {self.status})"
