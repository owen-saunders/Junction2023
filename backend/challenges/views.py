from django.db.models.aggregates import Count
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import action

from .models import Challenge, Post, Participant, TileMap
from .serializers import (
    ChallengeSerializer,
    PostSerializer,
    ParticipantSerializer,
    TileMapSerializer,
)

from datetime import datetime


class ChallengeViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Challenge.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = ChallengeSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ["title"]

    def get_queryset(self):
        qs = self.queryset
        only_my_challenges = self.request.query_params.get("my_challenges", None)
        if only_my_challenges:
            me = self.request.user
            # Filter by challenges which I am a participant
            my_challenges = Participant.objects.filter(user=me).values_list(
                "challenge", flat=True
            )

            # Filter posts by those challenges
            qs = qs.filter(pk__in=my_challenges)
            return qs

        only_popular = self.request.query_params.get("popular", None)
        if only_popular:
            # Order posts by number of participants
            # Participant.objects.filter(challenge=obj.pk).count()
            qs = qs.annotate(num_participants=Count('participants'))
            qs = qs.order_by("-num_participants")[:6]
            return qs

        return super().get_queryset()



class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = PostSerializer

    def get_queryset(self):
        qs = self.queryset
        # Only my posts for all my teams'/groups' challenges
        only_my_challenges = self.request.query_params.get("my_challenges", None)
        if only_my_challenges:
            me = self.request.user
            # Filter by challenges which I am a participant
            my_challenges = Participant.objects.filter(user=me).values_list(
                "challenge", flat=True
            )

            # Filter posts by those challenges
            qs = qs.filter(challenge__in=my_challenges)
            return qs

        # All posts for my teams'/groups' challenges
        challenge = self.request.query_params.get("challenge", None)
        if challenge:
            qs = qs.filter(challenge__pk=challenge)
        return qs


class ParticipantViewSet(viewsets.ModelViewSet):
    queryset = Participant.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = ParticipantSerializer


class TileViewSet(viewsets.ModelViewSet):
    queryset = TileMap.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = TileMapSerializer

    def get_queryset(self):
        # Make sure I can only get my own tilemap, or my friends' tilemaps
        qs = self.queryset
        me = self.request.user
        my_friends = me.friends.all()

        current_year = datetime.now().year

        # Get the year requested, defaulting to the current year
        year = self.request.query_params.get("year", current_year)

        # Get the tilemap for the user requested
        user_id = self.request.query_params.get("user_id", me.pk)

        # Check if the user is a friend, or if the user is me
        if user_id == me.pk or my_friends.filter(pk=user_id).exists():
            # Return the tilemap for the user requested (single tilemap)
            return qs.filter(owner__pk=user_id, year=year)
        # Else return a 404
        return qs.none()

    def retrieve(self, request, *args, **kwargs):
        """Get the tilemap for the user requested."""
        qs = self.get_queryset()
        me = self.request.user
        my_friends = me.friends.all()

        # Get the user and year
        user_id = self.request.query_params.get("user_id")
        year = self.request.query_params.get("year")

        # Check if the user is a friend, or if the user is me
        if user_id == me.pk or my_friends.filter(pk=user_id).exists():
            # Return the tilemap for the user requested
            if qs.filter(owner__pk=user_id, year=year).exists():
                tilemap = qs.get(owner__pk=user_id, year=year)
            else:
                # If the tilemap isn't for the current year, return a 404
                if int(year) != datetime.now().year:
                    return Response("No data for this year.", status=404)
                # Create a new tilemap for the user requested
                tilemap = TileMap.objects.create(owner_id=user_id)
            return Response(TileMapSerializer(tilemap).data)
        # Else return a 403 Forbidden
        return Response("Tilemap not viewable. Tilemap's owner must be a friend.", status=403)

    def update(self, request, *args, **kwargs):
        """Update the tilemap for the user requested."""

        # Can only update my own tilemap
        me = self.request.user
        if me.pk != int(request.data["owner"]):
            return Response("You can only update your own tilemap.", status=403)

        # Can only update the current year's tilemap
        current_year = datetime.now().year
        if int(request.data["year"]) != current_year:
            return Response("You can only update the current year's tilemap.", status=403)

        return super().update(request, *args, **kwargs)

    @action(detail=False, methods=["GET"], url_path="my-tilemap")
    def get_my_tilemap(self, request):
        """Get the tilemap for the current year."""
        user_id = request.user.pk
        # Check if the user has a tilemap for the current year, and create one if not
        tilemap, _ = TileMap.objects.get_or_create(owner=user_id, year=datetime.now().year)
        serializer = TileMapSerializer(tilemap, context={"request": request})
        return Response(serializer.data)
