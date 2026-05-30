from django.urls import path

from apps.content import views

urlpatterns = [
    path("careers/<str:slug>/stories/", views.CareerStoriesView.as_view()),
    path("careers/<str:slug>/resources/", views.CareerResourcesView.as_view()),
]
