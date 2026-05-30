"""
AI Chat router — conversations, messages.

GET   /api/v1/ai/conversations/
POST  /api/v1/ai/conversations/
GET   /api/v1/ai/conversations/{conversation_id}/
POST  /api/v1/ai/conversations/{conversation_id}/messages/
DELETE /api/v1/ai/conversations/{conversation_id}/
"""

from uuid import UUID
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, Query, status
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from core.database import get_db
from core.dependencies import get_current_user
from core.exceptions import NexStepException
from core.config import settings
from models.user import User
from models.career import Career
from models.ai_chat import AIConversation, AIMessage
from schemas.ai_chat import (
    StartConversationRequest, SendMessageRequest,
    AIMessageOut,
)


router = APIRouter()


@router.get("/conversations/")
async def list_conversations(
    conversation_type: str | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """List all AI conversations."""
    query = (
        select(AIConversation)
        .options(selectinload(AIConversation.career))
        .where(AIConversation.user_id == current_user.id, AIConversation.is_active == True)
    )
    if conversation_type:
        query = query.where(AIConversation.conversation_type == conversation_type)
    query = query.order_by(AIConversation.last_message_at.desc().nullslast())

    result = await db.execute(query)
    conversations = result.scalars().all()

    data = []
    for c in conversations:
        data.append({
            "id": str(c.id),
            "conversation_type": c.conversation_type,
            "career": {"slug": c.career.slug, "name": c.career.name} if c.career else None,
            "title": c.title,
            "message_count": c.message_count,
            "last_message_at": c.last_message_at,
            "is_active": c.is_active,
        })

    return {"success": True, "data": data}


@router.post("/conversations/", status_code=201)
async def start_conversation(
    body: StartConversationRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Start a new AI conversation."""
    career = None
    career_id = None
    if body.conversation_type == "career_specific" and body.career_slug:
        stmt = select(Career).where(Career.slug == body.career_slug)
        career = (await db.execute(stmt)).scalar_one_or_none()
        if not career:
            raise NexStepException(code="CAREER_NOT_FOUND", message="Career not found.", http_status=404)
        career_id = career.id

    now = datetime.now(timezone.utc)

    # Create conversation
    conversation = AIConversation(
        user_id=current_user.id,
        conversation_type=body.conversation_type,
        career_id=career_id,
        title=body.first_message[:200] if body.first_message else None,
        last_message_at=now,
        message_count=2,
    )
    db.add(conversation)
    await db.flush()

    # Save user message
    user_msg = AIMessage(
        conversation_id=conversation.id,
        role="user",
        content=body.first_message,
    )
    db.add(user_msg)
    await db.flush()

    # Call AI service (placeholder — in production, calls Anthropic)
    ai_response_text = (
        f"Thank you for your question about{' ' + career.name if career else ' careers'}! "
        "I'd love to help you explore this. Let me share some insights... "
        "(Note: AI integration will be connected in production.)"
    )

    assistant_msg = AIMessage(
        conversation_id=conversation.id,
        role="assistant",
        content=ai_response_text,
        tokens_used=0,
        model_version=settings.AI_MODEL,
    )
    db.add(assistant_msg)
    await db.flush()

    return {
        "success": True,
        "data": {
            "conversation_id": str(conversation.id),
            "conversation_type": conversation.conversation_type,
            "career": {"slug": career.slug, "name": career.name} if career else None,
            "title": conversation.title,
            "messages": [
                {
                    "id": str(user_msg.id),
                    "role": "user",
                    "content": user_msg.content,
                    "created_at": user_msg.created_at,
                },
                {
                    "id": str(assistant_msg.id),
                    "role": "assistant",
                    "content": assistant_msg.content,
                    "tokens_used": assistant_msg.tokens_used,
                    "model_version": assistant_msg.model_version,
                    "created_at": assistant_msg.created_at,
                },
            ],
        },
    }


@router.get("/conversations/{conversation_id}/")
async def get_conversation(
    conversation_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Get conversation with full message history."""
    stmt = (
        select(AIConversation)
        .options(selectinload(AIConversation.career), selectinload(AIConversation.messages))
        .where(AIConversation.id == conversation_id, AIConversation.user_id == current_user.id)
    )
    result = await db.execute(stmt)
    convo = result.scalar_one_or_none()

    if not convo:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Conversation not found.", http_status=404)

    messages = sorted(convo.messages, key=lambda m: m.created_at)

    return {
        "success": True,
        "data": {
            "conversation_id": str(convo.id),
            "conversation_type": convo.conversation_type,
            "career": {"slug": convo.career.slug, "name": convo.career.name} if convo.career else None,
            "title": convo.title,
            "message_count": convo.message_count,
            "started_at": convo.started_at,
            "last_message_at": convo.last_message_at,
            "messages": [
                {
                    "id": str(m.id),
                    "role": m.role,
                    "content": m.content,
                    "tokens_used": m.tokens_used,
                    "model_version": m.model_version,
                    "created_at": m.created_at,
                }
                for m in messages
            ],
        },
    }


@router.post("/conversations/{conversation_id}/messages/", status_code=201)
async def send_message(
    conversation_id: UUID,
    body: SendMessageRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Send a new message to an existing conversation."""
    convo = await db.get(AIConversation, conversation_id)
    if not convo or convo.user_id != current_user.id:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Conversation not found.", http_status=404)

    now = datetime.now(timezone.utc)

    # Save user message
    user_msg = AIMessage(
        conversation_id=conversation_id,
        role="user",
        content=body.content,
    )
    db.add(user_msg)
    await db.flush()

    # AI response (placeholder)
    ai_response_text = (
        "That's a great follow-up question! "
        "(Note: AI integration will be connected in production with the Anthropic SDK.)"
    )

    assistant_msg = AIMessage(
        conversation_id=conversation_id,
        role="assistant",
        content=ai_response_text,
        tokens_used=0,
        model_version=settings.AI_MODEL,
    )
    db.add(assistant_msg)

    convo.message_count += 2
    convo.last_message_at = now
    await db.flush()

    return {
        "success": True,
        "data": {
            "user_message": {
                "id": str(user_msg.id),
                "role": "user",
                "content": user_msg.content,
                "created_at": user_msg.created_at,
            },
            "assistant_message": {
                "id": str(assistant_msg.id),
                "role": "assistant",
                "content": assistant_msg.content,
                "tokens_used": assistant_msg.tokens_used,
                "model_version": assistant_msg.model_version,
                "created_at": assistant_msg.created_at,
            },
        },
    }


@router.delete("/conversations/{conversation_id}/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_conversation(
    conversation_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Soft-delete a conversation."""
    convo = await db.get(AIConversation, conversation_id)
    if not convo or convo.user_id != current_user.id:
        raise NexStepException(code="CAREER_NOT_FOUND", message="Conversation not found.", http_status=404)

    convo.is_active = False
    await db.flush()
    return None
