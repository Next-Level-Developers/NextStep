"""
AI service — Claude API wrapper.

In production, this calls the Anthropic SDK to generate responses.
"""

from core.config import settings


async def generate_ai_response(
    system_prompt: str,
    messages: list[dict],
) -> dict:
    """
    Call the Anthropic Claude API and return the response.

    Returns: { "content": str, "tokens_used": int, "model_version": str }

    In production, this would use:
        from anthropic import AsyncAnthropic
        client = AsyncAnthropic(api_key=settings.ANTHROPIC_API_KEY)
        response = await client.messages.create(...)
    """
    # Placeholder — returns a mock response
    return {
        "content": "I'd be happy to help you explore this career path! (AI integration pending.)",
        "tokens_used": 0,
        "model_version": settings.AI_MODEL,
    }
