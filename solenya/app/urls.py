"""web URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
"""
from django.urls import path

from . import views
from .admin_override import admin_site


urlpatterns = [
    path('', views.index, name='index'),
    path('robots.txt', views.robots, name='robots'),
    path('fingerprint/', views.client_fingerprint, name='fingerprint'),
    path('wubbalubbadubdub/', admin_site.urls),
]
