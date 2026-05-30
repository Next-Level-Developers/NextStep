"""
Subscriptions router — plans, orders, payments.

GET  /api/v1/subscriptions/plans/
POST /api/v1/subscriptions/create-order/
POST /api/v1/subscriptions/verify-payment/
GET  /api/v1/subscriptions/me/
"""

from uuid import UUID
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from core.database import get_db
from core.dependencies import get_current_user
from core.config import settings
from core.exceptions import NexStepException
from models.user import User
from models.subscription import SubscriptionPlan, SubscriptionTransaction
from schemas.subscription import CreateOrderRequest, VerifyPaymentRequest


router = APIRouter()


@router.get("/plans/")
async def list_plans(db: AsyncSession = Depends(get_db)):
    """All available subscription plans. No auth required."""
    stmt = select(SubscriptionPlan).order_by(SubscriptionPlan.price_paise)
    result = await db.execute(stmt)
    plans = result.scalars().all()

    data = []
    for p in plans:
        data.append({
            "id": str(p.id),
            "name": p.name,
            "display_name": p.name.replace("_", " ").title(),
            "price_paise": p.price_paise,
            "price_inr": p.price_paise // 100,
            "duration_days": p.duration_days,
            "features": p.features,
        })

    return {"success": True, "data": data}


@router.post("/create-order/", status_code=201)
async def create_order(
    body: CreateOrderRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Create a Razorpay order."""
    plan = await db.get(SubscriptionPlan, body.plan_id)
    if not plan:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Plan not found.", http_status=404)

    # Create Razorpay order (placeholder — in production, calls Razorpay SDK)
    razorpay_order_id = f"order_placeholder_{str(body.plan_id)[:8]}"

    transaction = SubscriptionTransaction(
        user_id=current_user.id,
        plan_id=plan.id,
        razorpay_order_id=razorpay_order_id,
        amount_paise=plan.price_paise,
        status="pending",
    )
    db.add(transaction)
    await db.flush()

    return {
        "success": True,
        "data": {
            "transaction_id": str(transaction.id),
            "razorpay_order_id": razorpay_order_id,
            "amount_paise": plan.price_paise,
            "currency": "INR",
            "razorpay_key_id": settings.RAZORPAY_KEY_ID,
        },
    }


@router.post("/verify-payment/")
async def verify_payment(
    body: VerifyPaymentRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Verify Razorpay signature and activate subscription."""
    transaction = await db.get(SubscriptionTransaction, body.transaction_id)
    if not transaction or transaction.user_id != current_user.id:
        raise NexStepException(code="PAYMENT_SIGNATURE_INVALID", message="Transaction not found.", http_status=400)

    # In production: verify Razorpay HMAC signature
    # razorpay_client.utility.verify_payment_signature(...)

    # Update transaction
    transaction.razorpay_payment_id = body.razorpay_payment_id
    transaction.status = "success"

    # Get plan for duration
    plan = await db.get(SubscriptionPlan, transaction.plan_id)
    duration = plan.duration_days or 30

    # Activate subscription
    current_user.subscription_tier = plan.name
    current_user.subscription_expires_at = datetime.now(timezone.utc) + timedelta(days=duration)

    await db.flush()

    return {
        "success": True,
        "data": {
            "subscription_tier": current_user.subscription_tier,
            "subscription_expires_at": current_user.subscription_expires_at,
            "transaction_id": str(transaction.id),
            "payment_id": body.razorpay_payment_id,
        },
    }


@router.get("/me/")
async def get_subscription(
    current_user: User = Depends(get_current_user),
):
    """Current user's active subscription."""
    now = datetime.now(timezone.utc)
    is_active = (
        current_user.subscription_tier != "free"
        and current_user.subscription_expires_at
        and current_user.subscription_expires_at > now
    )
    days_remaining = 0
    if current_user.subscription_expires_at and is_active:
        days_remaining = (current_user.subscription_expires_at - now).days

    return {
        "success": True,
        "data": {
            "subscription_tier": current_user.subscription_tier,
            "subscription_expires_at": current_user.subscription_expires_at,
            "days_remaining": days_remaining,
            "is_active": is_active,
            "plan": None,
        },
    }
