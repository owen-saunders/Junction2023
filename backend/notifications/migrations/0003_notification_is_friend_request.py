# Generated by Django 4.1.2 on 2023-04-05 09:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('notifications', '0002_notification_content_notification_datetime'),
    ]

    operations = [
        migrations.AddField(
            model_name='notification',
            name='is_friend_request',
            field=models.BooleanField(default=False),
        ),
    ]