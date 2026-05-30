from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from apps.users import views

urlpatterns = [
    path("auth/firebase/", views.FirebaseAuthView.as_view()),
    path("auth/token/refresh/", TokenRefreshView.as_view()),
    path("users/me/", views.MeView.as_view()),
    path("users/me/avatar/", views.AvatarUploadView.as_view()),
    path("users/me/student-profile/", views.StudentProfileView.as_view()),
    path("users/me/parental-consent/", views.ParentalConsentView.as_view()),
    path("users/me/share-token/", views.ShareTokenView.as_view()),
    path("share/profile/<str:share_token>/", views.ParentShareProfileView.as_view()),
    path("counsellor/dashboard/", views.CounsellorDashboardView.as_view()),
    path("counsellor/students/", views.CounsellorStudentsView.as_view()),
]
