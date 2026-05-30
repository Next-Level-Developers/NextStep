from django.urls import path

from apps.ai_chat import views

urlpatterns = [
    path("conversations/", views.ConversationListCreateView.as_view()),
    path("conversations/<uuid:conversation_id>/", views.ConversationDetailView.as_view()),
    path(
        "conversations/<uuid:conversation_id>/messages/",
        views.ConversationMessageCreateView.as_view(),
    ),
]
