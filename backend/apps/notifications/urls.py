from django.urls import path

from apps.notifications import views

urlpatterns = [
    path("", views.NotificationListView.as_view()),
    path("mark-all-read/", views.NotificationMarkAllReadView.as_view()),
    path("<uuid:notification_id>/read/", views.NotificationReadView.as_view()),
]
