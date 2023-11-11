from django.contrib.auth import authenticate, get_user_model, login, logout
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt

from rest_framework import viewsets, filters, status
from rest_framework.authtoken.models import Token
from rest_framework.decorators import action
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.throttling import UserRateThrottle

from users.serializers import UserSerializer
from .models import FriendRequest

from notifications.models import Notification


class UserViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list` and `retrieve` actions.
    """

    queryset = get_user_model().objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]

    @action(detail=False, methods=["get"], url_path="me", name="me")
    def me(self, request):
        """Get the current authenticated user"""
        serializer = self.get_serializer(request.user)
        return Response(serializer.data)

    @action(methods=["POST"], detail=False, url_path="send_friend_request")
    def send_friend_request(self, request):
        """Send a friend request to a user."""
        user_id = request.query_params.get("userID")
        from_user = request.user
        to_user = get_user_model().objects.get(id=user_id)

        # Check if from_user and to_user are friends
        if from_user.friends.filter(id=user_id).exists():
            return Response("You are already friends", status=status.HTTP_200_OK)
        
        friend_request, created = FriendRequest.objects.get_or_create(
            from_user=from_user, to_user=to_user
        )
        _, created = Notification.objects.get_or_create(
            user=to_user,
            title=f"Friend Request from {request.user.first_name}",
            content=f"{friend_request.pk}",
            is_friend_request=True,
        )
        if created:
            return Response("Friend Request Sent", status=status.HTTP_200_OK)
        return Response("Friend Request already sent", status=status.HTTP_200_OK)

    @action(methods=["POST"], detail=False, url_path="accept_friend_request")
    def accept_friend_request(self, request):
        requestID = request.query_params.get("requestID")
        friend_request = FriendRequest.objects.get(id=requestID)
        if friend_request.to_user == request.user:
            friend_request.to_user.friends.add(friend_request.from_user)
            friend_request.from_user.friends.add(friend_request.to_user)
            friend_request.delete()
            return Response("Friend Request Accepted")
        return Response("Friend Request Declined")


class LoginView(APIView):
    permission_classes = ()
    authentication_classes = ()
    throttle_classes = [UserRateThrottle]

    def post(self, request, format=None):
        username = request.data.get("username", None)
        password = request.data.get("password", None)
        print(username, password)
        if username is None or password is None:
            return Response(
                {"message": "Username and password cannot be empty"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        user = authenticate(username=username, password=password)
        print(user)
        if user is not None:
            if user.is_active:
                print("Bingo")
                login(request, user)
                # CsrfViewMiddleware automatically adds csrf token as cookie
                # SessionMiddleware automatically adds session id as cookie
                token, created = Token.objects.get_or_create(user=user)
                return Response(
                    {
                        "message": "Logged in successfully",
                        "user": UserSerializer(user).data,
                        "token": token.key,
                    },
                    status=status.HTTP_200_OK,
                )
            else:
                return Response(
                    {"message": "This account is not active!!"},
                    status=status.HTTP_401_UNAUTHORIZED,
                )
        else:
            return Response(
                {"message": "Invalid username or password!!"},
                status=status.HTTP_401_UNAUTHORIZED,
            )


@csrf_exempt
def logout_view(request):
    logout(request)
    return HttpResponse("Logged out", status=status.HTTP_200_OK)
