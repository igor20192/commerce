# Generated by Django 4.1.2 on 2022-12-04 15:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("auctions", "0012_transaction"),
    ]

    operations = [
        migrations.AlterField(
            model_name="transaction",
            name="test_ipn",
            field=models.IntegerField(),
        ),
    ]
