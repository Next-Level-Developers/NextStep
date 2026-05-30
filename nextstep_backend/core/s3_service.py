"""
S3 upload helpers using aioboto3.

Replaces django-storages + boto3 sync client.
"""

import uuid
from io import BytesIO

import aioboto3
from fastapi import UploadFile

from core.config import settings


async def upload_file_to_s3(
    file_content: bytes,
    s3_key: str,
    content_type: str = "application/octet-stream",
) -> str:
    """Upload raw bytes to S3 and return the public URL."""
    session = aioboto3.Session()
    async with session.client(
        "s3",
        region_name=settings.AWS_S3_REGION,
        aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
        aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
    ) as s3:
        await s3.put_object(
            Bucket=settings.AWS_S3_BUCKET_NAME,
            Key=s3_key,
            Body=file_content,
            ContentType=content_type,
        )
    return f"https://{settings.AWS_S3_BUCKET_NAME}.s3.{settings.AWS_S3_REGION}.amazonaws.com/{s3_key}"


async def upload_avatar_to_s3(file: UploadFile, user_id: uuid.UUID) -> str:
    """Upload a user avatar image to S3."""
    content = await file.read()
    ext = file.filename.rsplit(".", 1)[-1] if file.filename and "." in file.filename else "jpg"
    s3_key = f"avatars/{user_id}.{ext}"
    content_type = file.content_type or "image/jpeg"
    return await upload_file_to_s3(content, s3_key, content_type)
