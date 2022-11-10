from cProfile import label
from email.policy import default
from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    pass


class Category(models.Model):
    name = models.CharField(max_length=64)

    def __str__(self):
        return self.name


class Bid(models.Model):
    bid = models.IntegerField()
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
    name = models.CharField(max_length=64, default="", unique=True)
    brief_descrip = models.CharField(max_length=250, default="")
    categor = models.ForeignKey(Category, on_delete=models.CASCADE)
    product_name = models.CharField(max_length=64)
    description = models.TextField()
    image = models.ImageField(blank=True, upload_to="media")
    price = models.ForeignKey(Bid, on_delete=models.CASCADE)
    author_auct = models.CharField(max_length=64)
    active = models.BooleanField()
    commet = models.ManyToManyField(Comments, blank=True)

    def __str__(self) -> str:
        return self.name
