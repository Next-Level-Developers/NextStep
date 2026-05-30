"""
Custom exception classes and global exception handler.

Replaces DRF's exception handling.
"""

from fastapi import Request
from fastapi.responses import JSONResponse


class NexStepException(Exception):
    """Base exception for all NextStep business logic errors."""

    def __init__(
        self,
        code: str,
        message: str,
        http_status: int,
        details: dict | None = None,
    ):
        self.code = code
        self.message = message
        self.http_status = http_status
        self.details = details or {}
        super().__init__(message)


async def nextstep_exception_handler(request: Request, exc: NexStepException):
    """Global exception handler registered on the FastAPI app."""
    return JSONResponse(
        status_code=exc.http_status,
        content={
            "success": False,
            "error": {
                "code": exc.code,
                "message": exc.message,
                "details": exc.details,
            },
        },
    )
