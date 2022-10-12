import site
from django.contrib import admin

from auctions.views import register
from .models import Auction, Bid, Category, Comments, User

# Register your models here.
admin.site.register(Auction)
admin.site.register(Bid),
admin.site.register(Comments)
admin.site.register(Category)
admin.site.register(User)
