"""
Firebase Admin SDK initialisation and async token verifier.

Replaces utils/firebase_auth.py from the Django project.
"""

import json

import firebase_admin
from firebase_admin import credentials, auth as firebase_auth

from core.config import settings
from core.exceptions import NexStepException


_firebase_initialised = False


def init_firebase() -> None:
    """Initialise Firebase Admin SDK. Called once at app startup via lifespan."""
    global _firebase_initialised
    if _firebase_initialised:
        return

    if settings.FIREBASE_CREDENTIALS_PATH:
        cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
    elif settings.FIREBASE_CREDENTIALS_JSON:
        cred = credentials.Certificate(json.loads(settings.FIREBASE_CREDENTIALS_JSON))
    else:
        # Skip Firebase init if no credentials provided (local dev without Firebase)
        return

    firebase_admin.initialize_app(cred)
    _firebase_initialised = True


async def verify_firebase_token(token: str) -> dict:
    """
    Verify a Firebase ID token and return the decoded claims.

    Returns dict with keys like 'uid', 'email', 'name', etc.
    Raises NexStepException with code INVALID_FIREBASE_TOKEN on failure.
    """
    try:
        decoded_token = firebase_auth.verify_id_token(token)
        return decoded_token
    except Exception:
        raise NexStepException(
            code="INVALID_FIREBASE_TOKEN",
            message="Firebase token verification failed.",
            http_status=401,
        )
