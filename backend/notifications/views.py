from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response

# Create your views here.

from .models import Notification
from .serializers import NotificationSerializer


class NotificationViewSet(viewsets.ModelViewSet):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    @action(methods=["PATCH"], detail=False)
    def read_all(self, request, **kwargs):
        Notification.objects.filter(user=self.request.user, read=False).update(
            read=True
        )
        return Response({"Success": "Marked all as read."}, status=status.HTTP_200_OK)
