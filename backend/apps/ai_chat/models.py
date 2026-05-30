import uuid

from django.conf import settings
from django.db import models


class AIConversation(models.Model):
    class ConversationType(models.TextChoices):
        GENERAL = "general", "general"
        CAREER_SPECIFIC = "career_specific", "career_specific"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="ai_conversations",
    )
    conversation_type = models.CharField(max_length=20, choices=ConversationType.choices)
    career = models.ForeignKey(
        "careers.Career",
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="ai_conversations",
    )
    title = models.CharField(max_length=300, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    started_at = models.DateTimeField(auto_now_add=True)
    last_message_at = models.DateTimeField(blank=True, null=True)
    message_count = models.IntegerField(default=0)

    class Meta:
        db_table = "ai_conversations"
        indexes = [
            models.Index(fields=["user"], name="ai_conversations_user_idx"),
            models.Index(
                fields=["conversation_type"], name="ai_conversations_type_idx"
            ),
        ]

    def __str__(self):
        return f"AIConversation({self.user_id}, {self.conversation_type})"


class AIMessage(models.Model):
    class Role(models.TextChoices):
        USER = "user", "user"
        ASSISTANT = "assistant", "assistant"

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    conversation = models.ForeignKey(
        "ai_chat.AIConversation",
        on_delete=models.CASCADE,
        related_name="messages",
    )
    role = models.CharField(max_length=10, choices=Role.choices)
    content = models.TextField()
    tokens_used = models.IntegerField(blank=True, null=True)
    model_version = models.CharField(max_length=50, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "ai_messages"
        indexes = [
            models.Index(fields=["conversation"], name="ai_messages_convo_idx"),
            models.Index(fields=["created_at"], name="ai_messages_created_at_idx"),
        ]

    def __str__(self):
        return f"AIMessage({self.conversation_id}, {self.role})"
