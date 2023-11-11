from rest_framework import serializers

from .models import Challenge, Post, Participant, Segment, Hexagon, TileMap

from datetime import datetime

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


class SegmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Segment
        fields = [
            "type",
            "position",
        ]


class HexagonSerializer(serializers.ModelSerializer):
    segments = SegmentSerializer(many=True)
    class Meta:
        model = Hexagon
        fields = [
            "segments",
        ]


class TileMapSerializer(serializers.ModelSerializer):
    hexagons = HexagonSerializer(many=True)
    class Meta:
        model = TileMap
        fields = [
            "hexagons",
            "year",
        ]
        read_only_fields = [
            "year",
        ]

    def create(self, validated_data):
        """Custom create method to handle nested serializers."""
        # Create 1024 hexagons and set default value as having no segments for each
        hexagons = []
        for _ in range(1024):
            hexagon, _ = Hexagon.objects.get_or_create(segments=None)
            hexagons.append(hexagon)
        validated_data["hexagons"] = hexagons
        validated_data["year"] = datetime.now().year
        return super().create(validated_data)

    def update(self, instance, validated_data):
        """Custom update method to handle nested serializers"""
        hexagons_data = validated_data.pop("hexagons")

        # Expected data format for hexagons_data:
        # [
        #     {   
        #         "position": 1, # 1 to 1024
        #         "segments": [
        #             {
        #                 "type": 1,
        #                 "position": 1
        #             },
        #             ...
        #         ]
        #     },
        #     ...
        # ]
        # of which there are 1024 hexagons, and each hexagon has upto 6 segments

        # Get the hexagons from the validated data and change the instance's hexagons at those positions
        hexagons = list(instance.hexagons.all())
        print(hexagons)

        # For each hexagon, update the segments
        for hexagon_data in hexagons_data:
            segments_data = hexagon_data.pop("segments")
            
            hexagon = Hexagon.objects.create()  # No segments by default
            # For each segment in the 6 segments, update the type and position by creating a new segment
            for segment_data in segments_data:
                # There are a finite number of combinations of type and position (6 * 5 * 4 * 3 * 2 * 1 = 720)
                # So we can just get_or_create a segment with the given type and position
                segment, _ = Segment.objects.get_or_create(**segment_data)
                # We don't need to add the segment to the hexagon if it's type is 0 (inactive), the default,
                # because all hexagons specify the position of the active segments (Sparsification)
                hexagon.segments.add(segment)  # Order here doesn't matter
            hexagon.save()
            # Change the hexagon at the given position
            if hexagon_data["position"] > 0 and hexagon_data["position"] <= 1024:
                hexagons[hexagon_data["position"] - 1] = hexagon
            else:
                raise serializers.ValidationError("Hexagon position must be between 1 and 1024.")

        # Update all given hexagons
        instance.hexagons.set(hexagons)
        instance.save()
        return super().update(instance, validated_data)
