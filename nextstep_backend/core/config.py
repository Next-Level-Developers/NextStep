"""
NextStep — Pydantic BaseSettings configuration.

Reads all config from .env file. Replaces Django's settings.py.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict
from functools import lru_cache
from typing import List


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    # ── App ────────────────────────────────────────────────────
    APP_ENV: str = "development"
    APP_SECRET_KEY: str = "change-me"
    APP_DEBUG: bool = False
    ALLOWED_HOSTS: List[str] = ["localhost"]

    # ── Database ───────────────────────────────────────────────
    DB_HOST: str = "localhost"
    DB_PORT: int = 5432
    DB_NAME: str = "nextstep_db"
    DB_USER: str = "nextstep_user"
    DB_PASSWORD: str = ""
    DB_SSLMODE: str = "disable"
    DB_SSLROOTCERT: str | None = None

    @property
    def DATABASE_URL(self) -> str:
        return (
            f"postgresql+asyncpg://{self.DB_USER}:{self.DB_PASSWORD}"
            f"@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
        )

    @property
    def DATABASE_URL_SYNC(self) -> str:
        """Sync URL for Alembic migrations."""
        return (
            f"postgresql://{self.DB_USER}:{self.DB_PASSWORD}"
            f"@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
        )

    # ── JWT ────────────────────────────────────────────────────
    JWT_SECRET_KEY: str = "change-me"
    JWT_ALGORITHM: str = "HS256"
    JWT_ACCESS_TOKEN_EXPIRE_MINUTES: int = 60
    JWT_REFRESH_TOKEN_EXPIRE_DAYS: int = 30

    # ── AWS S3 ─────────────────────────────────────────────────
    AWS_ACCESS_KEY_ID: str = ""
    AWS_SECRET_ACCESS_KEY: str = ""
    AWS_S3_BUCKET_NAME: str = "nextstep-assets"
    AWS_S3_REGION: str = "ap-south-1"

    # ── Firebase ───────────────────────────────────────────────
    FIREBASE_CREDENTIALS_PATH: str | None = None
    FIREBASE_CREDENTIALS_JSON: str | None = None
    FIREBASE_PROJECT_ID: str | None = None

    # ── AI (Anthropic) ─────────────────────────────────────────
    ANTHROPIC_API_KEY: str = ""
    AI_MODEL: str = "claude-sonnet-4-20250514"
    AI_MAX_TOKENS: int = 1000
    AI_FREE_DAILY_MESSAGE_LIMIT: int = 5

    # ── Razorpay ───────────────────────────────────────────────
    RAZORPAY_KEY_ID: str = ""
    RAZORPAY_SECRET: str = ""

    # ── Redis / Celery ─────────────────────────────────────────
    REDIS_URL: str = "redis://localhost:6379/0"

    # ── CORS ───────────────────────────────────────────────────
    CORS_ORIGINS: List[str] = ["http://localhost:8080", "https://nextstep.app"]


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
