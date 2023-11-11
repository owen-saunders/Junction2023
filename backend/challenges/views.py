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


class TileViewSet(viewsets.GenericViewSet):
    queryset = TileMap.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = TileMapSerializer

    @action(detail=False, methods=["GET"], url_path="my")
    def get_my_tilemap(self, request, *args, **kwargs):
        """Get the tilemap for the user requested."""

        # Can only get my own tilemap
        me = self.request.user
        year = self.request.query_params.get("year", datetime.now().year)

        # Check if tilemap exists
        if not self.queryset.filter(owner=me, year=year).exists():
            if int(year) < datetime.now().year:
                return Response("No data for the requested year.", status=404)
            # Create a new tilemap
            tilemap = TileMapSerializer().create(validated_data={
                "owner": me,
                "year": year,
            })
            tilemap.save()
        data = TileMapSerializer(self.queryset.filter(owner=me, year=year).first()).data
        return Response(data, status=200)


    @action(detail=False, methods=["POST"], url_path="my")
    def update_tilemap(self, request, *args, **kwargs):
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
