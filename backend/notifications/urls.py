from django.urls import path, include
from rest_framework.routers import SimpleRouter

from . import views

router = SimpleRouter()
router.register(r"notifications", views.NotificationViewSet, basename="notifications")


urlpatterns = [
    path("", include(router.urls)),
]
