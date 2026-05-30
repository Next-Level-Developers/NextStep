"""
Async SQLAlchemy engine, session factory, and declarative base.

Replaces Django's DATABASES setting and ORM connection management.
"""

from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import DeclarativeBase

from core.config import settings
import os
import ssl


def get_engine_kwargs() -> dict:
    """Constructs the engine keyword arguments, including SSL configuration for RDS."""
    kwargs = {}
    if settings.DB_SSLMODE in ("verify-full", "verify-ca", "require"):
        cert_path = settings.DB_SSLROOTCERT
        if cert_path:
            if not os.path.isabs(cert_path):
                # Make path relative to backend root
                backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
                cert_path = os.path.join(backend_dir, cert_path)
            
            ssl_context = ssl.create_default_context(cafile=cert_path)
            if settings.DB_SSLMODE == "verify-ca":
                ssl_context.check_hostname = False
            elif settings.DB_SSLMODE == "verify-full":
                ssl_context.check_hostname = True
            ssl_context.verify_mode = ssl.CERT_REQUIRED
            kwargs["connect_args"] = {"ssl": ssl_context}
        else:
            kwargs["connect_args"] = {"ssl": True}
    return kwargs


engine = create_async_engine(
    settings.DATABASE_URL,
    pool_size=10,
    max_overflow=20,
    pool_pre_ping=True,
    echo=settings.APP_DEBUG,
    **get_engine_kwargs(),
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    expire_on_commit=False,
    class_=AsyncSession,
)


class Base(DeclarativeBase):
    pass


async def get_db() -> AsyncSession:
    """FastAPI dependency — injects a DB session into route handlers."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
