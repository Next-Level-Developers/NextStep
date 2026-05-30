from django.urls import path

from apps.recommendations import views

urlpatterns = [
    path("", views.RecommendationsListView.as_view()),
    path("regenerate/", views.RecommendationsRegenerateView.as_view()),
    path("saved/", views.SavedCareersView.as_view()),
]
