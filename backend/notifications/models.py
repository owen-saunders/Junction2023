from django.db import models

# Create your models here.


class Notification(models.Model):
    title = models.CharField(max_length=127)
    read = models.BooleanField(default=False)
    user = models.ForeignKey("users.User", on_delete=models.CASCADE)
    content = models.TextField(null=True, blank=True)
    datetime = models.DateTimeField(auto_now_add=True)
    is_friend_request = models.BooleanField(default=False)
