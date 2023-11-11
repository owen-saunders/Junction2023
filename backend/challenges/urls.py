from django.urls import path, include
from rest_framework.routers import SimpleRouter

from . import views

router = SimpleRouter()
router.register(r"feeds", views.PostViewSet, basename="feeds")


urlpatterns = [
    path("", include(router.urls)),
]
