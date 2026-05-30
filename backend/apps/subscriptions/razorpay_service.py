import hmac
import os
from hashlib import sha256


def verify_signature(order_id, payment_id, signature):
    secret = os.environ.get("RAZORPAY_SECRET", "")
    payload = f"{order_id}|{payment_id}".encode("utf-8")
    expected = hmac.new(secret.encode("utf-8"), payload, sha256).hexdigest()
    return hmac.compare_digest(expected, signature)
