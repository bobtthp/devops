from django.conf.urls import url
from . import views
from . import log_view
from . import login
from . import dlog
from . import update
from . import kvm
from django.contrib import admin
urlpatterns = [
    url(r'^index', views.index,name='index'),
    url(r'^info', views.listinfo,name='info'),
    url(r'^loginfo',log_view.testlog,name='loginfo'),
    url(r'^pinfo',views.pinfo,name='pinfo'),
    url(r'^$',login.userlogin,name='login'),
    url(r'^register',login.userregist,name='register'),
    url(r'^logout',login.userlogout,name='logout'),
    url(r'^getlog',dlog.download,name='getlog'),
    url(r'^update',update.upanme,name='update'),
    url(r'^commit',update.commit,name='commit'),
    url(r'^kvm',kvm.api,name='kvm'),
    url(r'^kstart',kvm.start,name='kstart'),
    url(r'^kstop',kvm.stop,name='kstop'),
    url(r'^krestart',kvm.restart,name='krestart')

    ]