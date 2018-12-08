# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0003_user'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='service',
            options={},
        ),
        migrations.AlterModelOptions(
            name='user',
            options={'managed': True},
        ),
    ]
