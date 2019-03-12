import json
import logging
import pickle

from django.http import HttpResponse, \
    HttpResponseNotAllowed, HttpResponseBadRequest
from django.shortcuts import render
from django.template import Template, Context
from django.views.decorators.csrf import csrf_exempt


logger = logging.getLogger(__name__)


def index(request):
    context = {}
    html = Template('{% load static %}<img src="{% static "p-rick.png" %}" />')
    return HttpResponse(html.render(Context(request)))


def robots(request):
    context = {}
    return render(request, 'robots.txt', context, content_type='text/plain')


@csrf_exempt
def client_fingerprint(request):
    if not request.method == 'POST':
        html = Template('{% load static %}<img src="{% static "farewell.jpg" %}" />')
        return HttpResponse(html.render(Context(request)))
    if 'HTTP_TOKEN' not in request.META:
        return HttpResponseBadRequest()
    if request.META['HTTP_TOKEN'] != 'SSdtIFBpY2tsZSBSaWNrIQ==':
        return HttpResponseBadRequest()

    try:
        pickle_data = pickle.loads(request.body)
    except:
        logger.warning('Exception when loading pickle: {0}'.format(pickle_data))
        return HttpResponse(status=400)

    return HttpResponse()
