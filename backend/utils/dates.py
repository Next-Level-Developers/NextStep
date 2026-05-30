from datetime import timedelta

from django.utils import timezone


def expires_at_from_days(days):
    return timezone.now() + timedelta(days=days)
