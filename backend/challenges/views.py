from django.db.models.aggregates import Count
from rest_framework import viewsets, filters
from rest_framework.permissions import IsAuthenticated

from .models import Challenge, Post, Participant
from .serializers import (
    ChallengeSerializer,
    PostSerializer,
    ParticipantSerializer,
)


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
        # All posts for all my challenges
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

        # All posts for challenge
        challenge = self.request.query_params.get("challenge", None)
        if challenge:
            qs = qs.filter(challenge__pk=challenge)
        return qs


class ParticipantViewSet(viewsets.ModelViewSet):
    queryset = Participant.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = ParticipantSerializer
