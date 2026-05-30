import os

import firebase_admin
from firebase_admin import auth, credentials


_app = None


def _get_firebase_app():
    global _app
    if _app is not None:
        return _app

    credentials_path = os.environ.get("FIREBASE_CREDENTIALS_PATH")
    if credentials_path:
        cred = credentials.Certificate(credentials_path)
        _app = firebase_admin.initialize_app(cred)
    else:
        _app = firebase_admin.initialize_app()
    return _app


def verify_firebase_token(token):
    _get_firebase_app()
    return auth.verify_id_token(token)
