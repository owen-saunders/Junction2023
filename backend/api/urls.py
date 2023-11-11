"""
URL configuration for api project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.conf import settings
from django.conf.urls.static import static
from django.http import HttpResponse
from django.urls import path, include, re_path
from django.utils.translation import gettext_lazy as _

from drf_yasg.views import get_schema_view
from drf_yasg import openapi

from rest_framework import permissions
from rest_framework.routers import DefaultRouter


from users.views import LoginView, logout_view

from users.urls import router as users_router
from challenges.urls import router as challenge_router
from notifications.urls import router as notifications_router

"""V1 ROUTER"""
router = DefaultRouter()

router.registry.extend(users_router.registry)
router.registry.extend(challenge_router.registry)
router.registry.extend(notifications_router.registry)

# Default API Info
api_info = openapi.Info(
    title="Sustainable Challenges API",
    default_version="v1",
    description="This is the documentation for the Sustainable Challenges API",
    license=openapi.License(name="MIT License"),
)
settings.SWAGGER_SETTINGS["DEFAULT_INFO"] = api_info

# Schema
SchemaView = get_schema_view(
    public=True,
    permission_classes=[permissions.AllowAny],
)

# Obtain a reference to the DefaultAdmin using admin.site
# and update the default values
admin.site.site_title = _("WeSweat")
admin.site.site_header = _("WeSweat Administration")
admin.site.index_title = _("Control Center Home")

urlpatterns = [
    path("api/admin/", admin.site.urls),
    path("api/v1/", include(router.urls)),
    path("api/auth/", include("rest_framework.urls")),
    path("api/login/", LoginView.as_view(), name="login"),
    path("api/logout/", logout_view, name="logout"),
    re_path(
        r"^swagger(?P<format>\.json|\.yaml)$",
        SchemaView.without_ui(cache_timeout=0),
        name="schema-json",
    ),
    re_path(
        r"^docs/$", SchemaView.with_ui("redoc", cache_timeout=0), name="schema-redoc"
    ),
    path(
        "",
        lambda _: HttpResponse(
            '<div style="max-width: 400px;font-family: Helvetica, Sans-Serif;font-size: 1.2em;margin: 20vh '
            'auto;"><p>"<strong>200 OK.</strong> Welcome to the WeSweat API."</p></div>',
            headers={"content-type": "text/html"},
            status=200,
        ),
        name="api-test",
    ),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
