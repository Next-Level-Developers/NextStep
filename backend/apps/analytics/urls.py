from django.urls import path

from apps.analytics import views

urlpatterns = [
    path("events/", views.AnalyticsEventCreateView.as_view()),
]
