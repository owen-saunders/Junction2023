from django.contrib.auth import get_user_model
from rest_framework import serializers

from .models import FriendRequest


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = [
            "id",
            "username",
            "first_name",
            "last_name",
            "email",
            "profile_picture",
            "friends",
        ]


class FriendRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = FriendRequest
        fields = [
            "to_user",
            "from_user",
        ]
