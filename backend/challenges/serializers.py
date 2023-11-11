from rest_framework import serializers

from .models import Challenge, Post, Participant


class ChallengeSerializer(serializers.ModelSerializer):
    participants = serializers.SerializerMethodField()
    name = serializers.CharField(source="owner.first_name")

    class Meta:
        model = Challenge
        fields = [
            "id",
            "title",
            "short_description",
            "reward",
            "long_description",
            "owner",
            "name",
            "participants",
        ]

    def get_participants(self, obj):
        return Participant.objects.filter(challenge=obj.pk).count()


class PostSerializer(serializers.ModelSerializer):
    # Profile Pic
    # Name
    profile_picture = serializers.FileField(source="owner.profile_picture", required=False)
    name = serializers.CharField(source="owner.first_name", required=False)
    likes = serializers.SerializerMethodField()

    class Meta:
        model = Post
        fields = [
            "challenge",
            "title",
            "owner",
            "profile_picture",
            "name",
            "likes",
            "datetime",
        ]
        read_only_fields = [
            "owner",
        ]

    def get_likes(self, obj):
        # likes = Post.objects.filter(pk=obj.pk).annotate(
        #     likes=Count('liked_by')
        # ).values_list("likes", flat=True)
        return obj.liked_by.all().count()

    def create(self, validated_data):
        user = self.context['request'].user
        validated_data["owner"] = user

        return super().create(validated_data)


class ParticipantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participant
        fields = [
            "user",
            "challenge",
        ]
