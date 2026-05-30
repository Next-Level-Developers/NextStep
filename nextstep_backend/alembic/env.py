"""
Alembic async migration environment.

Imports all models so autogenerate detects them.
"""

import asyncio
import sys
from pathlib import Path

from alembic import context
from sqlalchemy import pool
from sqlalchemy.ext.asyncio import create_async_engine

# Add the project root to sys.path so imports work
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from core.config import settings
from core.database import Base, get_engine_kwargs

# Import all models for autogenerate
import models  # noqa: F401

target_metadata = Base.metadata


def run_migrations_offline():
    """Run migrations in 'offline' mode (SQL script output)."""
    url = settings.DATABASE_URL
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def do_run_migrations(connection):
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()


async def run_migrations_online():
    """Run migrations in 'online' mode with async engine."""
    connectable = create_async_engine(
        settings.DATABASE_URL,
        poolclass=pool.NullPool,
        **get_engine_kwargs(),
    )

    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)

    await connectable.dispose()


if context.is_offline_mode():
    run_migrations_offline()
else:
    asyncio.run(run_migrations_online())
