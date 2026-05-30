from django.urls import path

from apps.profiler import views

urlpatterns = [
    path("questions/", views.QuestionsView.as_view()),
    path("sessions/", views.SessionCreateView.as_view()),
    path("sessions/<uuid:session_id>/", views.SessionDetailView.as_view()),
    path("sessions/<uuid:session_id>/responses/", views.SessionResponsesView.as_view()),
    path("sessions/<uuid:session_id>/complete/", views.SessionCompleteView.as_view()),
    path("profile/", views.ActiveProfileView.as_view()),
]
