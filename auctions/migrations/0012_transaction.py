# Generated by Django 4.1.2 on 2022-12-04 15:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("auctions", "0011_auction_paid_alter_auction_active_and_more"),
    ]

    operations = [
        migrations.CreateModel(
            name="Transaction",
            fields=[
                (
                    "id",
                    models.AutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("payment_date", models.DateTimeField()),
                ("receiver_email", models.EmailField(max_length=254)),
                ("test_ipn", models.ImageField(upload_to="")),
                ("item_namex", models.CharField(max_length=127)),
                ("auth_amount", models.DecimalField(decimal_places=2, max_digits=9)),
                ("mc_currency", models.CharField(max_length=3)),
                ("address_country", models.CharField(max_length=100)),
                ("address_city", models.CharField(max_length=100)),
                ("address_name", models.CharField(max_length=128)),
                ("address_street", models.CharField(max_length=200)),
                ("address_zip", models.CharField(max_length=20)),
                ("first_name", models.CharField(max_length=64)),
                ("last_name", models.CharField(max_length=64)),
                ("contact_phone", models.CharField(max_length=20)),
                ("payer_email", models.EmailField(max_length=254)),
            ],
        ),
    ]
