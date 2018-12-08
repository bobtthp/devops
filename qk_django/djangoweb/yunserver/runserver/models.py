#coding:utf-8
from __future__ import unicode_literals

from django.db import models


class AppAliasBak(models.Model):
    app_id = models.IntegerField(blank=True, null=True)
    alias = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'app_alias_bak'


class AtmLog(models.Model):
    create_time = models.DateTimeField(blank=True, null=True)
    data = models.CharField(max_length=500, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'atm_log'


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=80)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class Azurevm(models.Model):
    resname = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'类型')
    name = models.CharField(unique=True, max_length=255, blank=True, null=True, verbose_name=u'名称')
    ipaddr = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'IP地址')
    vmtype = models.IntegerField(blank=True, null=True)
    state = models.IntegerField(blank=True, null=True, default=0)
    opened = models.IntegerField(blank=True, null=True, default=0)
    otime = models.DateTimeField(blank=True, null=True)
    closed = models.IntegerField(blank=True, null=True, default=0)
    ctime = models.DateTimeField(blank=True, null=True)
    delayedoff = models.IntegerField(blank=True, null=True, default=0)
    autostart = models.IntegerField(blank=True, null=True, default=0)
    autodelay = models.IntegerField(blank=True, null=True, default=0)

    class Meta:
        managed = False
        db_table = 'azurevm'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class Downlog(models.Model):
    projectname = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'项目名称')
    serverip = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'服务器ip')
    serverport = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'SSH端口')
    username = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'SSH用户名')
    password = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'SSH密码')
    location = models.CharField(max_length=255, blank=True, null=True, verbose_name=u'日志位置')

    class Meta:
        managed = False
        db_table = 'downlog'


class Faq(models.Model):
    cat_id = models.IntegerField(blank=True, null=True)
    clicked = models.IntegerField(blank=True, null=True)
    question = models.CharField(max_length=255)
    answer = models.TextField(blank=True, null=True)
    author = models.CharField(max_length=3, blank=True, null=True)
    create_time = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'faq'


class FaqCat(models.Model):
    faq_cat_id = models.AutoField(primary_key=True)
    cat_name = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'faq_cat'


class Loginuser(models.Model):
    namechs = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'loginuser'


class Lost(models.Model):
    lost = models.CharField(max_length=255, blank=True, null=True)
    mark = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'lost'


class NoPoweroff(models.Model):
    name = models.CharField(unique=True, max_length=255, blank=True, null=True)
    state = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'no_poweroff'


class Pentesting(models.Model):
    id = models.AutoField(db_column='Id', primary_key=True)  # Field name made lowercase.
    proname = models.CharField(max_length=255)
    prourl = models.CharField(max_length=255, blank=True, null=True)
    proauth = models.CharField(max_length=255, blank=True, null=True)
    proqq = models.CharField(max_length=255, blank=True, null=True)
    prohost = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'pentesting'


class Poweron(models.Model):
    name = models.CharField(unique=True, max_length=255, blank=True, null=True)
    state = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'poweron'


class Prolist(models.Model):
    tname = models.CharField(max_length=255, blank=True, null=True)
    sendtime = models.DateTimeField(blank=True, null=True)
    upversion = models.CharField(max_length=255, blank=True, null=True)
    version = models.CharField(max_length=255, blank=True, null=True)
    year = models.CharField(max_length=255, blank=True, null=True)
    month = models.CharField(max_length=255, blank=True, null=True)
    auth = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prolist'


class WebappBak(models.Model):
    app_name = models.CharField(max_length=255)
    app_ipaddr = models.IntegerField(blank=True, null=True)
    db_ipaddr = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'webapp_bak'
