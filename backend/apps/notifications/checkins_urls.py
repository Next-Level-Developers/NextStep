from django.urls import path

from apps.notifications import views

urlpatterns = [
    path("", views.CheckInListView.as_view()),
    path("<uuid:check_in_id>/respond/", views.CheckInRespondView.as_view()),
]
