from django.db import models
from django.contrib.auth import get_user_model

from datetime import datetime


class Post(models.Model):
    challenge = models.ForeignKey(
        "Challenge", null=False, blank=False, on_delete=models.CASCADE
    )
    title = models.CharField(max_length=127)
    owner = models.ForeignKey(
        "users.User", null=False, blank=False, related_name="posts", on_delete=models.CASCADE
    )
    liked_by = models.ManyToManyField("users.User", blank=True, related_name="likes")

    datetime = models.DateTimeField(auto_now_add=True)



class Challenge(models.Model):
    title = models.CharField(null=False, blank=False, max_length=255)
    short_description = models.TextField(null=False, blank=False, max_length=280)
    reward = models.CharField(null=True, blank=True, max_length=280)
    long_description = models.TextField(null=False, blank=False)

    # photo = models.FileField() # TODO: Add photo field

    owner = models.ForeignKey(
        "users.User", null=False, blank=False, on_delete=models.CASCADE
    )

    def __str__(self):
        return f"{self.title}"


class Participant(models.Model):
    user = models.ForeignKey(
        "users.User", null=False, blank=False, on_delete=models.CASCADE
    )
    challenge = models.ForeignKey(
        "Challenge", null=False, blank=False, related_name="participants", on_delete=models.CASCADE
    )



class Segment(models.Model):
    class SegmentType(models.IntegerChoices):
        INACTIVE = 0
        STRENGTH = 1
        AGILITY = 2
        AEROBIC = 3
        FLEXIBILITY = 4
    type = models.PositiveSmallIntegerField(choices=SegmentType.choices, default=0)
    position = models.PositiveSmallIntegerField(default=1, unique=True)

    class Meta:
        # There should be no duplicate segments stored in the database
        constraints = [
            models.UniqueConstraint(
                fields=["type", "position"],
                name="unique_segment",
            ),
            # Max and min values for position
            models.CheckConstraint(
                check=models.Q(position__gte=1) & models.Q(position__lte=6),
                name="position_range",
            ),
        ]


class Hexagon(models.Model):
    """Our hexagons are divided into 6 segments, each of which can be one of n types.

    Our 6 segments represent sequential time periods during which the user is active.
    
    Our N types are:
    - 0: Inactive
    - 1: Strength, High Intensity
    - 2: Agility, Reaction
    - 3: Aerobic, Endurance
    - 4: Flexibility, Balance and Coordination
    """
    segments = models.ManyToManyField(Segment, related_name="hexagon_segments", blank=True)


class TileMap(models.Model):
    """Stores an array of 32 by 32 hexagons, of which the majority are empty/inactive."""
    hexagons = models.ManyToManyField(Hexagon, related_name="tilemap_hexagons", max_length=1024, blank=True)
    year = models.PositiveSmallIntegerField(default=2023, unique=True)
    owner = models.ForeignKey(get_user_model(), null=False, blank=False, on_delete=models.CASCADE)
