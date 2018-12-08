# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0004_auto_20180814_1345'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='service',
            options={'managed': False},
        ),
    ]
