"""
Razorpay service — SDK wrapper for payment operations.

In production, this uses the razorpay Python SDK.
"""

from core.config import settings


def create_razorpay_order(amount_paise: int, currency: str = "INR") -> dict:
    """
    Create a Razorpay order.

    In production:
        import razorpay
        client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_SECRET))
        order = client.order.create({
            "amount": amount_paise,
            "currency": currency,
            "payment_capture": 1,
        })
        return order
    """
    # Placeholder
    return {
        "id": "order_placeholder",
        "amount": amount_paise,
        "currency": currency,
    }


def verify_payment_signature(
    razorpay_order_id: str,
    razorpay_payment_id: str,
    razorpay_signature: str,
) -> bool:
    """
    Verify Razorpay payment signature.

    In production:
        import razorpay
        client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_SECRET))
        client.utility.verify_payment_signature({
            "razorpay_order_id": razorpay_order_id,
            "razorpay_payment_id": razorpay_payment_id,
            "razorpay_signature": razorpay_signature,
        })
    """
    # Placeholder — always returns True
    return True
