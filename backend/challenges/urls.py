from django.urls import path, include
from rest_framework.routers import SimpleRouter

from . import views

router = SimpleRouter()
router.register(r"challenges", views.ChallengeViewSet, basename="challenges")
router.register(r"feeds", views.PostViewSet, basename="feeds")
router.register(r"participate", views.ParticipantViewSet, basename="participate")


urlpatterns = [
    path("", include(router.urls)),
]
