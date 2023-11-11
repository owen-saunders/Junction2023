from django.contrib import admin
from django.contrib.auth import get_user_model
from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext_lazy as _

# Register your models here.


@admin.register(get_user_model())
class CustomUserAdmin(UserAdmin):
    """Override the Default UserAdmin."""
    search_fields = ["email", "first_name", "last_name"]
    list_filter = ["is_staff", "is_superuser"]
    list_display = [
        "email",
        "first_name",
        "last_name",
    ]
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        (_("Personal info"), {"fields": ("first_name", "last_name", "email")}),
        (
            _("Permissions"),
            {
                "fields": (
                    "fcm_token",
                    "is_verified",
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "user_permissions",
                    "friends",
                    "profile_picture",
                ),
            },
        ),
        (
            _("Important dates"),
            {"fields": ("last_login",)},
        ),
    )
    readonly_fields = ["id"]

    def get_ordering(self, request):
        return ["email"]
