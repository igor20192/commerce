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
    bid = models.PositiveIntegerField()
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

    def __str__(self) -> str:
        return self.name
