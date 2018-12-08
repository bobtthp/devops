
from django.conf.urls import include, url
from django.conf.urls.static import  serve
from django.conf import settings


urlpatterns = [
    #url(r'^admin/', admin.site.urls),
    url(r'^runserver/', include('runserver.urls')),
    url(r'^$', include('runserver.urls')),
    url(r'^media/(.*)$', serve, {'document_root': settings.STATIC_PATH}),

]

