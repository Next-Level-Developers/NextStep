"""
Firebase Admin SDK initialisation and async token verifier.

Replaces utils/firebase_auth.py from the Django project.
"""

import json
import time
import httpx
from jose import jwt

import firebase_admin
from firebase_admin import credentials, auth as firebase_auth

from core.config import settings
from core.exceptions import NexStepException


_firebase_initialised = False

# Cache for Google's public certificates (to avoid fetching on every login request)
_google_certs_cache: dict = {}
_google_certs_fetched_at: float = 0.0


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


async def _get_google_public_certs() -> dict:
    """Fetch and cache Google's public certificates for Firebase ID tokens."""
    global _google_certs_cache, _google_certs_fetched_at
    now = time.time()
    
    # Cache certificates for 1 hour (3600 seconds)
    if _google_certs_cache and (now - _google_certs_fetched_at < 3600):
        return _google_certs_cache
        
    certs_url = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    async with httpx.AsyncClient() as client:
        resp = await client.get(certs_url)
        resp.raise_for_status()
        _google_certs_cache = resp.json()
        _google_certs_fetched_at = now
        
    return _google_certs_cache


async def _verify_token_fallback(token: str) -> dict:
    """
    Manually verify Firebase ID token JWT signature using Google's public certs.
    Used during local development when Firebase Admin SDK is not initialized.
    """
    try:
        header = jwt.get_unverified_header(token)
        kid = header.get("kid")
        if not kid:
            raise ValueError("Token header missing 'kid'")
            
        claims = jwt.get_unverified_claims(token)
        project_id = settings.FIREBASE_PROJECT_ID
        
        # If project ID is not explicitly set in config, we infer it from the token
        if not project_id:
            project_id = claims.get("aud")
            # Enforce that issuer matches the inferred project ID
            expected_iss = f"https://securetoken.google.com/{project_id}"
            if claims.get("iss") != expected_iss:
                raise ValueError("Token issuer does not match audience")
        
        certs = await _get_google_public_certs()
        if kid not in certs:
            raise ValueError(f"Key ID '{kid}' not found in Google's public certificates")
            
        cert = certs[kid]
        
        # Verify JWT signature and claims (with 5 min leeway for clock skew)
        decoded = jwt.decode(
            token,
            cert,
            algorithms=["RS256"],
            audience=project_id,
            issuer=f"https://securetoken.google.com/{project_id}",
            options={
                "verify_exp": True,
                "verify_iat": True,
                "verify_nbf": True,
                "leeway": 300,
            }
        )
        
        # Map 'sub' claim to 'uid' for full compatibility with official Admin SDK output
        if "uid" not in decoded and "sub" in decoded:
            decoded["uid"] = decoded["sub"]
            
        return decoded
        
    except Exception as e:
        # Print warning/error trace to backend logs for developer debugging
        print(f"[Firebase Fallback Verification Error]: {e}")
        raise NexStepException(
            code="INVALID_FIREBASE_TOKEN",
            message=f"Firebase token verification failed: {str(e)}",
            http_status=401,
        )


async def verify_firebase_token(token: str) -> dict:
    """
    Verify a Firebase ID token and return the decoded claims.

    Returns dict with keys like 'uid', 'email', 'name', etc.
    Raises NexStepException with code INVALID_FIREBASE_TOKEN on failure.
    """
    if _firebase_initialised:
        try:
            decoded_token = firebase_auth.verify_id_token(token)
            return decoded_token
        except Exception:
            raise NexStepException(
                code="INVALID_FIREBASE_TOKEN",
                message="Firebase token verification failed.",
                http_status=401,
            )
    else:
        # Fallback to pure-python JWT verification if Admin SDK was skipped (local dev)
        return await _verify_token_fallback(token)
