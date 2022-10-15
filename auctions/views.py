from unicodedata import name
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.db import IntegrityError
from django.forms import ValidationError
from django.http import HttpResponseRedirect, HttpResponse
from django.shortcuts import render
from django.urls import reverse

from .models import User, Auction, Category, Bid
from .forms import MakeBetForms


def index(request):
    context = dict(quantity=len(request.session.get("my_auction", [])))
    return render(request, "auctions/index.html", context)


def login_view(request):
    if request.method == "POST":

        # Attempt to sign user in
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)

        # Check if authentication successful
        if user is not None:
            login(request, user)
            return HttpResponseRedirect(reverse("index"))
        else:
            return render(
                request,
                "auctions/login.html",
                {"message": "Invalid username and/or password."},
            )
    else:
        return render(request, "auctions/login.html")


def logout_view(request):
    logout(request)
    return HttpResponseRedirect(reverse("index"))


def register(request):
    if request.method == "POST":
        username = request.POST["username"]
        email = request.POST["email"]

        # Ensure password matches confirmation
        password = request.POST["password"]
        confirmation = request.POST["confirmation"]
        if password != confirmation:
            return render(
                request, "auctions/register.html", {"message": "Passwords must match."}
            )

        # Attempt to create new user
        try:
            user = User.objects.create_user(username, email, password)
            user.save()
        except IntegrityError:
            return render(
                request,
                "auctions/register.html",
                {"message": "Username already taken."},
            )
        login(request, user)
        return HttpResponseRedirect(reverse("index"))
    else:
        return render(request, "auctions/register.html")


def get_category(request, category):
    context = dict(
        auction=Auction.objects.filter(
            categor=Category.objects.get(name=category)
        ).filter(active=True),
        category=category,
        quantity=len(request.session.get("my_auction", [])),
    )
    return render(request, "auctions/activ_auctions.html", context)


@login_required
def category(request, categor):
    if categor == "Electronics":
        return get_category(request, "Electronics")
    if categor == "Fashion":
        return get_category(request, "Fashion")
    if categor == "Home":
        return get_category(request, "Home")
    if categor == "Toys":
        return get_category(request, "Toys")


def add_auction(request, name):
    if not request.session.get("my_auction"):
        request.session["my_auction"] = []
    lst = request.session["my_auction"]
    lst.append(name)
    request.session["my_auction"] = lst
    return HttpResponseRedirect("/")


def del_auction(request, name):
    lst = request.session.get("my_auction")
    lst.remove(name)
    request.session["my_auction"] = lst
    return HttpResponseRedirect(reverse("my_auction"))


def my_auction(request):
    session = request.session.get("my_auction")
    context = {}
    context["quantity"] = len(request.session.get("my_auction", []))

    if session:
        context["auction"] = [
            Auction.objects.get(name=value, active=True) for value in session
        ]
        return render(request, "auctions/my_auctions.html", context)
    return HttpResponseRedirect(reverse("index"))


def check_rate(name_auction, bid):
    price = Auction.objects.get(name=name_auction).price.bid
    if bid > price:
        return True
    return False


def make_a_bet(request, name):
    context = dict(
        auction=Auction.objects.get(name=name),
        quantity=len(request.session.get("my_auction", [])),
        form=MakeBetForms(),
    )

    if context["auction"].name in request.session.get("my_auction", []):
        context["add_auction"] = True

    if request.method == "POST":
        form = MakeBetForms(request.POST)
        if form.is_valid():
            bid = form.cleaned_data.get("bid")
            if check_rate(name, bid):
                obj = Auction.objects.get(name=name).id
                Bid.objects.filter(auction=obj).update(
                    bid=bid, author_bid=str(request.user)
                )
                return render(request, "auctions/auction.html", context)
            return HttpResponse("The bid must be greater than the current price")
    return render(request, "auctions/auction.html", context)
