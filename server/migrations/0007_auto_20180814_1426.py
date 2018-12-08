# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0006_auto_20180814_1413'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='service',
            options={},
        ),
        migrations.RemoveField(
            model_name='service',
            name='pro_name',
        ),
        migrations.AddField(
            model_name='service',
            name='log_addr',
            field=models.CharField(max_length=50, null=True),
        ),
        migrations.AddField(
            model_name='service',
            name='passwd',
            field=models.CharField(default=datetime.datetime(2018, 8, 14, 6, 24, 27, 604000, tzinfo=utc), max_length=20),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='service',
            name='project_name',
            field=models.CharField(default=datetime.datetime(2018, 8, 14, 6, 24, 36, 436000, tzinfo=utc), max_length=20),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='service',
            name='username',
            field=models.CharField(default=datetime.datetime(2018, 8, 14, 6, 26, 0, 356000, tzinfo=utc), max_length=20),
            preserve_default=False,
        ),
    ]
