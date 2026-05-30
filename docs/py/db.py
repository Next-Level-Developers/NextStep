"""
database.py — AWS RDS PostgreSQL connection for FastAPI
Uses SQLAlchemy async engine for non-blocking DB calls.
"""

import os
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker
from dotenv import load_dotenv

load_dotenv()

# ── Connection URL ────────────────────────────────────────────────────────────
# Set these in your .env file or AWS environment variables
DB_HOST     = os.getenv("DB_HOST")           # your-rds-endpoint.rds.amazonaws.com
DB_PORT     = os.getenv("DB_PORT", "5432")
DB_NAME     = os.getenv("DB_NAME", "nextstep")
DB_USER     = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

DATABASE_URL = (
    f"postgresql+asyncpg://{DB_USER}:{DB_PASSWORD}"
    f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

# ── Engine ────────────────────────────────────────────────────────────────────
engine = create_async_engine(
    DATABASE_URL,
    echo=False,          # Set True during development to see SQL logs
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,  # Detect stale connections (important for RDS)
)

# ── Session factory ───────────────────────────────────────────────────────────
AsyncSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
    autocommit=False,
)

# ── Base class for all models ─────────────────────────────────────────────────
class Base(DeclarativeBase):
    pass


# ── FastAPI dependency ────────────────────────────────────────────────────────
async def get_db() -> AsyncSession:
    """Inject a DB session into FastAPI route handlers."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()


# ── Create all tables (call on startup) ──────────────────────────────────────
async def create_tables():
    """
    Create all tables defined in models.
    Called from lifespan() in main.py.
    For production, use Alembic migrations instead.
    """
    async with engine.begin() as conn:
        from app.models import Base as ModelsBase  # noqa: F401 — ensures all models are registered
        await conn.run_sync(ModelsBase.metadata.create_all)