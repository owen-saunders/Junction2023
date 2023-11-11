from django.contrib import admin

from .models import Challenge, Post, Participant


@admin.register(Challenge)
class ChallengeAdmin(admin.ModelAdmin):
    list_display = (
        "title",
        "owner",
    )
    list_display_links = ("title",)
    fields = (
        "title",
        "short_description",
        "reward",
        "long_description",
        "owner",
    )
    search_fields = ("title",)


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ("title", "challenge", "owner")
    list_display_links = ("title",)
    fields = (
        "challenge",
        "title",
        "owner",
        "liked_by",
    )
    search_fields = ("name",)


@admin.register(Participant)
class ParticipantAdmin(admin.ModelAdmin):
    list_display = ("user", "challenge")
    list_display_links = ("user",)
    fields = (
        "user",
        "challenge",
    )
    search_fields = ("user", "challenge")
