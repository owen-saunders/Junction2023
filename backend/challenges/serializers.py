from rest_framework import serializers

from .models import Post




class PostSerializer(serializers.ModelSerializer):
    # Profile Pic
    # Name
    name = serializers.CharField(source="owner.first_name", required=False)
    likes = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = [
            "title",
            "owner",
            "name",
            "likes",
            "datetime",
        ]
        read_only_fields = [
            "owner",
        ]

    def create(self, validated_data):
        user = self.context['request'].user
        validated_data["owner"] = user

        return super().create(validated_data)
