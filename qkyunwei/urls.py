"""qkyunwei URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.8/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf.urls import include, url
from django.contrib import admin
from django.conf.urls.static import serve
from django.conf import settings
from server import login



urlpatterns = [
   # url(r'^$',login.userlogin),
    url(r'^bob_admin', admin.site.urls),
    url(r'^servicelist/',include('server.urls',namespace='server')),
    url(r'^static/(.*)', serve, {'document_root':settings.STATIC_PATH}),   #static file path
    url(r'^static1/(.*)', serve, {'document_root':settings.STATIC_PATH1}),

]
