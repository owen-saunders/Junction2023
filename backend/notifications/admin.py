from django.contrib import admin

from .models import Notification


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ("user", "title", "datetime", "read")
    list_display_links = ("title",)
    fields = (
        "user",
        "title",
        "read",
        "content",
        "datetime",
        "is_friend_request",
    )
    readonly_fields = ["datetime"]
    search_fields = ("user", "challenge")
