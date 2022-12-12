from django.urls import path
from django.views.generic import TemplateView
from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("login", views.login_view, name="login"),
    path("logout", views.logout_view, name="logout"),
    path("register", views.register, name="register"),
    path("category/<str:categor>", views.category, name="category"),
    path("category/auction/<str:name>/<str:categor>", views.make_a_bet, name="auction"),
    path(
        "category/auction/add_auction/<str:name>/<str:categor>",
        views.add_auction,
        name="add_auction",
    ),
    path("my_auction", views.my_auction, name="my_auction"),
    path("del_auction/<str:name>/<str:categor>", views.del_auction, name="del_auction"),
    path(
        "close_the_auction/<str:name>",
        views.close_the_auction,
        name="close_the_auction",
    ),
    path("close_auction", views.close_auction_list, name="close_auction"),
    path("winner_auction/<str:name>", views.get_winner_auction, name="winner_auction"),
    path("comments/<str:name>/<str:categor>", views.comments, name="comments"),
    path("make_auction", views.make_auction, name="make_auction"),
    path(
        "payment/<str:price>/<str:name>", views.view_that_asks_for_money, name="payment"
    ),
    path(
        "success",
        TemplateView.as_view(template_name="paypal/success.html"),
        name="success",
    ),
]
