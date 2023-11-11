from django.db import models


class Post(models.Model):
    challenge = models.ForeignKey(
        "Challenge", null=False, blank=False, on_delete=models.CASCADE
    )
    photo = models.FileField()
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
