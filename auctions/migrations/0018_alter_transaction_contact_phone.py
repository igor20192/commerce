# Generated by Django 4.1.2 on 2022-12-04 18:25

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("auctions", "0017_transaction_txn_id"),
    ]

    operations = [
        migrations.AlterField(
            model_name="transaction",
            name="contact_phone",
            field=models.IntegerField(),
        ),
    ]
