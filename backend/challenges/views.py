from django.db.models.aggregates import Sum, Count
from rest_framework import viewsets, filters, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Post
from .serializers import PostSerializer


class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = PostSerializer
