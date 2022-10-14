from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("login", views.login_view, name="login"),
    path("logout", views.logout_view, name="logout"),
    path("register", views.register, name="register"),
    path("category/<str:categor>", views.category),
    path("category/auction/<str:name>", views.get_auction, name="auction"),
    path("category/auction/add_auction/<str:name>", views.add_auction),
    path("my_auction", views.my_auction, name="my_auction"),
    path("del_auction/<str:name>", views.del_auction, name="del_auction"),
]
