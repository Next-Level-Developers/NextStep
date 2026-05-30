from django.urls import path

from apps.roadmaps import views

urlpatterns = [
    path("", views.RoadmapListCreateView.as_view()),
    path("progress-summary/", views.RoadmapProgressSummaryView.as_view()),
    path("<uuid:roadmap_id>/", views.RoadmapDetailView.as_view()),
    path("<uuid:roadmap_id>/steps/<uuid:step_id>/progress/", views.RoadmapStepProgressView.as_view()),
]
