# Generated by Django 4.1.2 on 2022-12-04 18:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("auctions", "0016_rename_item_namex_transaction_item_name"),
    ]

    operations = [
        migrations.AddField(
            model_name="transaction",
            name="txn_id",
            field=models.CharField(default="", max_length=20),
            preserve_default=False,
        ),
    ]
