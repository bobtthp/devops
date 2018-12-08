#coding: utf8
from django.conf.urls import url
from . import views

app_name = 'runserver'

urlpatterns = [
    url(r"^$", views.show),
    url(r'^list$', views.show, name='list'),
    url(r'^update$', views.command, name='update'),
    url(r'^ushow$', views.ushow, name='ushow'),
    url(r'^sshow$', views.sshow, name='sshow'),
    url(r'^testshow$', views.showtest, name='showtest'),
    url(r'^create$', views.create, name='create'),
    url(r'^edit/(\d+)', views.edit, name='edit'),
    url(r'^log$', views.createLog, name='createLog'),
    url(r'^listlog$', views.listlog, name='listlog'),
    url(r'^logedit/(\d+)', views.logedit, name='logedit'),
    url(r'^vm$', views.vmcreate, name='vmcreate'),



]