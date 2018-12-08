from django.db import models
from django.contrib.auth.models import AbstractBaseUser, UserManager


class Service(models.Model):
    id = models.IntegerField(primary_key=True)
    ip = models.CharField(max_length=20)
    project_name = models.CharField(max_length=20)
    username = models.CharField(max_length=20)
    passwd = models.CharField(max_length=20)
    log_addr = models.CharField(max_length=50,null=True)
    class Meta:
        managed = True
        db_table = 'server_info'


class User(models.Model):
    username = models.CharField(max_length=20)
    password = models.CharField(max_length=32)
    class Meta:
        managed = True
        db_table = 'user_info'


