from django.contrib import admin

from .models import Post


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ("title", "owner", "datetime")
    list_display_links = ("title",)
    fields = (
        "title",
        "owner",
        "liked_by",
        "datetime",
    )
    readonly_fields = ["datetime"]
    search_fields = ("name",)
