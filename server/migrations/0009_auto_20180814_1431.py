# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('server', '0008_auto_20180814_1427'),
    ]

    operations = [
        migrations.AlterField(
            model_name='service',
            name='id',
            field=models.IntegerField(serialize=False, primary_key=True),
        ),
    ]
