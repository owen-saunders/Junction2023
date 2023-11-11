from django.db import models


class Post(models.Model):
    title = models.CharField(max_length=127)
    owner = models.ForeignKey(
        "users.User", null=False, blank=False, related_name="posts", on_delete=models.CASCADE
    )
    liked_by = models.ManyToManyField("users.User", blank=True, related_name="likes")
    datetime = models.DateTimeField(auto_now_add=True)
