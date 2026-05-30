from django.urls import path

from apps.careers import views

urlpatterns = [
    path("", views.CareerListView.as_view()),
    path("domains/", views.CareerDomainsView.as_view()),
    path("domains/<str:slug>/", views.CareerDomainDetailView.as_view()),
    path("clusters/", views.CareerClustersView.as_view()),
    path("compare/", views.CareerCompareView.as_view()),
    path("<str:slug>/", views.CareerDetailView.as_view()),
    path("<str:slug>/save/", views.CareerSaveView.as_view()),
    path("<str:slug>/view/", views.CareerViewTrackView.as_view()),
]
