# Generated by Django 4.1.2 on 2023-04-04 18:11

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ("notifications", "0001_initial"),
    ]

    operations = [
        migrations.AddField(
            model_name="notification",
            name="content",
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name="notification",
            name="datetime",
            field=models.DateTimeField(
                auto_now_add=True, default=django.utils.timezone.now
            ),
            preserve_default=False,
        ),
    ]
