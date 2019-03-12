import datetime
import logging

from django.conf import settings
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import User


logger = logging.getLogger(__name__)


def get_client_ip(request):
    """
    Return the source host of a request object.
    """
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


class ChallengeAuthBackend:
    """
    Always return failed login.
    """
    def authenticate(self, request, username=None, password=None):
        timestamp = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M"))
        host = get_client_ip(request)
        msg = '[{0}] Attempted login {{host: "{1}", user: "{2}", password: "{3}"}}'
        msg = msg.format(timestamp, host, username, password)
        logger.info(msg)
        return None

    def get_user(self, user_id):
        return None
