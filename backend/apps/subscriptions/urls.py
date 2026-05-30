from django.urls import path

from apps.subscriptions import views

urlpatterns = [
    path("plans/", views.PlansListView.as_view()),
    path("create-order/", views.CreateOrderView.as_view()),
    path("verify-payment/", views.VerifyPaymentView.as_view()),
    path("me/", views.SubscriptionMeView.as_view()),
]
