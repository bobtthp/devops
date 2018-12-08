# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0005_auto_20180814_1358'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='service',
            options={'managed': True},
        ),
    ]
