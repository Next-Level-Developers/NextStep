"""
Subscription and payment request/response schemas.
"""

from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional, List


class PlanFeatures(BaseModel):
    career_matches: int = 5
    career_detail_full: bool = False
    roadmap_steps_visible: int = 3
    ai_messages_per_day: int = 5
    stories_per_career: int = 1
    career_comparison: bool = False
    parent_share: bool = False
    progress_tracker: bool = False


class SubscriptionPlanOut(BaseModel):
    id: UUID
    name: str
    display_name: str = ""
    price_paise: int
    price_inr: int = 0
    duration_days: Optional[int] = None
    features: dict

    model_config = {"from_attributes": True}


class CreateOrderRequest(BaseModel):
    plan_id: UUID


class CreateOrderResponse(BaseModel):
    transaction_id: UUID
    razorpay_order_id: str
    amount_paise: int
    currency: str = "INR"
    razorpay_key_id: str


class VerifyPaymentRequest(BaseModel):
    transaction_id: UUID
    razorpay_order_id: str
    razorpay_payment_id: str
    razorpay_signature: str


class VerifyPaymentResponse(BaseModel):
    subscription_tier: str
    subscription_expires_at: datetime
    transaction_id: UUID
    payment_id: str


class UserSubscriptionOut(BaseModel):
    subscription_tier: str
    subscription_expires_at: Optional[datetime] = None
    days_remaining: int = 0
    is_active: bool = False
    plan: Optional[SubscriptionPlanOut] = None
