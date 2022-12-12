from django.templatetags.static import static
from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    pass


class Category(models.Model):
    name = models.CharField(max_length=64)

    def __str__(self):
        return self.name


class Bid(models.Model):
    bid = models.DecimalField(max_digits=9, decimal_places=2)
    author_bid = models.CharField(max_length=64)
    date_bid = models.DateTimeField(auto_now=True)

    def __str__(self):
        return str(self.bid)


class Comments(models.Model):
    auction_name = models.CharField(max_length=64)
    comments = models.TextField("Add comments")
    author_comments = models.CharField(max_length=64)
    date_comm = models.DateTimeField(auto_now=True)


class Auction(models.Model):
    name = models.CharField(
        max_length=64, default="", unique=True, help_text="This field must be unique"
    )
    brief_descrip = models.CharField(max_length=250, default="")
    categor = models.ForeignKey(Category, on_delete=models.CASCADE)
    product_name = models.CharField(max_length=64)
    description = models.TextField()
    image = models.ImageField(
        blank=True,
        upload_to="media",
        default=("not_photo.jpeg"),
    )
    image1 = models.ImageField(
        blank=True,
        upload_to="media",
        default=("not_photo1.jpeg"),
    )
    image2 = models.ImageField(
        blank=True,
        upload_to="media",
        default=("not_photo2.jpeg"),
    )
    image3 = models.ImageField(
        blank=True,
        upload_to="media",
        default=("not_photo3.jpeg"),
    )
    price = models.ForeignKey(Bid, on_delete=models.CASCADE)
    author_auct = models.CharField(max_length=64)
    active = models.BooleanField(default=True)
    commet = models.ManyToManyField(Comments, blank=True)
    paid = models.BooleanField(default=False)

    def __str__(self) -> str:
        return self.name


class Transaction(models.Model):
    payment_date = models.DateTimeField()
    receiver_email = models.EmailField()
    txn_id = models.CharField(max_length=20)
    test_ipn = models.IntegerField()
    item_name = models.CharField(verbose_name="item name", max_length=127)
    auth_amount = models.DecimalField(max_digits=9, decimal_places=2)
    mc_currency = models.CharField(max_length=3)
    address_country = models.CharField(max_length=100)
    address_city = models.CharField(max_length=100)
    address_name = models.CharField(max_length=128, blank=True)
    address_street = models.CharField(max_length=200)
    address_zip = models.CharField(max_length=20)
    first_name = models.CharField(max_length=64)
    last_name = models.CharField(max_length=64)
    contact_phone = models.CharField(max_length=20)
    payer_email = models.EmailField()

    def __str__(self):
        return self.item_name
