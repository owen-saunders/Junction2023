from rest_framework import serializers

from .models import Notification


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = [
            "user",
            "title",
            "read",
            "content",
            "datetime",
            "is_friend_request",
        ]
