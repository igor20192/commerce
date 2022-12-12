from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.db import IntegrityError
from django.http import HttpResponseRedirect, HttpResponse
from django.shortcuts import render
from django.urls import reverse
from django.db.utils import IntegrityError
from django.conf import settings


from paypal.standard.forms import PayPalPaymentsForm
from .models import User, Auction, Category, Bid, Comments
from .forms import MakeBetForms, CommentsForm, MakeAuction
from bs4 import BeautifulSoup
import requests
from decimal import Decimal

template_registr = "auctions/register.html"
template_auction = "auctions/auction.html"


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
                request, template_registr, {"message": "Passwords must match."}
            )

        # Attempt to create new user
        try:
            user = User.objects.create_user(username, email, password)
            user.save()
        except IntegrityError:
            return render(
                request,
                template_registr,
                {"message": "Username already taken."},
            )
        login(request, user)
        return HttpResponseRedirect(reverse("index"))
    else:
        return render(request, template_registr)


def get_category(request, category):
    context = dict(
        auction=Auction.objects.filter(
            categor=Category.objects.get(name=category)
        ).filter(active=True),
        category=category,
        quantity=len(request.session.get("my_auction", [])),
        list_category=Category.objects.exclude(name=category),
    )
    return render(request, "auctions/activ_auctions.html", context)


@login_required
def category(request, categor):
    if categor == "Electronics":
        return get_category(request, "Electronics")
    if categor == "Fashion":
        return get_category(request, "Fashion")
    if categor == "For home":
        return get_category(request, "For home")
    if categor == "Toys":
        return get_category(request, "Toys")


@login_required
def add_auction(request, name, categor):
    if not request.session.get("my_auction"):
        request.session["my_auction"] = []
    lst = request.session["my_auction"]
    lst.append(name)
    request.session["my_auction"] = lst
    return HttpResponseRedirect(reverse(make_a_bet, args=[name, categor]))


@login_required
def del_auction(request, name, categor):
    lst = request.session.get("my_auction")
    lst.remove(name)
    request.session["my_auction"] = lst
    return HttpResponseRedirect(reverse(make_a_bet, args=[name, categor]))


@login_required
def my_auction(request):
    session = request.session.get("my_auction")

    context = dict(quantity=len(request.session.get("my_auction", [])), auction=[])

    if session:
        for name_auct in session:
            obj = Auction.objects.get(name=name_auct)
            if obj.active:
                context["auction"].append(obj)
            else:
                session.remove(obj.name)
        request.session["my_auction"] = session
        context["quantity"] = len(session)
        return render(request, "auctions/my_auctions.html", context)
    return HttpResponseRedirect("/")


def check_rate(name_auction, bid):
    price = Auction.objects.get(name=name_auction).price.bid
    if bid > price:
        return True
    return False


def get_context(request, name):
    context = dict(
        auction=Auction.objects.get(name=name),
        quantity=len(request.session.get("my_auction", [])),
        form=MakeBetForms(),
        form_comment=CommentsForm(),
        users=str(request.user),
        comments=Comments.objects.filter(auction_name=name),
    )

    if context["auction"].name in request.session.get("my_auction", []):
        context["add_auction"] = True
    return context


@login_required
def make_a_bet(request, name, categor):
    context = dict(list_category=Category.objects.exclude(name=categor))
    if request.method == "POST":
        form = MakeBetForms(request.POST)
        if form.is_valid():
            bid = form.cleaned_data.get("bid")
            if check_rate(name, bid):
                obj = Auction.objects.get(name=name).id
                Bid.objects.filter(auction=obj).update(
                    bid=bid, author_bid=str(request.user)
                )
                context["success"] = "Bet successfully placed!"
                return render(
                    request, template_auction, get_context(request, name) | context
                )
            context["warning"] = "The bid must be greater than the current price"

    return render(request, template_auction, get_context(request, name) | context)


@login_required
def close_the_auction(request, name):
    Auction.objects.filter(name=name).update(active=False)
    return HttpResponseRedirect(reverse(close_auction_list))


@login_required
def close_auction_list(request):
    context = dict(
        close_auction=Auction.objects.filter(active=False),
        quantity=len(request.session.get("my_auction", [])),
    )
    return render(request, "auctions/close_auction.html", context)


@login_required
def get_winner_auction(request, name):
    auctions = Auction.objects.get(name=name)
    context = dict(
        auctions=auctions, quantity=len(request.session.get("my_auction", []))
    )
    if str(request.user) == auctions.price.author_bid:
        context["winner"] = request.user

    return render(request, "auctions/winner_auction.html", context)


@login_required
def comments(request, name, categor):
    if request.method == ("POST"):
        form_comment = CommentsForm(request.POST)
        if form_comment.is_valid():
            comment = form_comment.cleaned_data.get("comments")
            obj = Auction.objects.get(name=name)
            Comments.objects.create(
                auction=obj,
                comments=comment,
                author_comments=str(request.user),
                auction_name=obj.name,
            )
    return HttpResponseRedirect(reverse("auction", args=[name, categor]))


@login_required
def make_auction(request):
    if request.method == "POST":
        form = MakeAuction(request.POST)

        try:
            obj = form.save(commit=False)
            auction_price = Bid.objects.create(
                bid=request.POST.get("price"), author_bid=str(request.user)
            ).id
            obj.price = Bid.objects.get(pk=auction_price)
            obj.author_auct = str(request.user)
            obj.save()

            return render(
                request, "auctions/auction.html", get_context(request, obj.name)
            )

        except Exception:
            return HttpResponse(
                "Check the entered data. Perhaps an auction with the same name already exists"
            )
    quantity = len(request.session.get("my_auction", []))
    form = MakeAuction()
    return render(
        request, "auctions/make_auction.html", {"form": form, "quantity": quantity}
    )


def exchange_rate_usd():
    url = "https://minfin.com.ua/ua/currency/usd/"
    try:
        response = requests.get(url)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "lxml")
        quotes = soup.find(
            "td", {"class": "mfm-text-nowrap", "data-title": "Курс гривні"}
        )
        return Decimal(quotes.contents[1].text[:7])
    except Exception as exc:
        raise requests.exceptions.RequestException(f"ERROR:{exc.__doc__}")


def view_that_asks_for_money(request, price, name):
    # What you want the button to do.
    obj = Auction.objects.get(name=name)
    paypal_dict = {
        "add": "1",
        "no_shipping": 2,
        "business": settings.PAYPAL_BUSINESS,
        "amount": Decimal(price) / exchange_rate_usd(),
        "item_name": obj.product_name,
        "invoice": obj.id,
        "notify_url": request.build_absolute_uri(reverse("paypal-ipn")),
        "return": request.build_absolute_uri(reverse("success")),
        "cancel_return": request.build_absolute_uri(
            reverse(get_winner_auction, args=[name])
        ),
        "custom": "premium_plan",  # Custom command to correlate to some function later (optional)
    }

    # Create the instance.
    form = PayPalPaymentsForm(initial=paypal_dict)
    context = {"form": form, "image": obj.image, "name": name}
    return render(request, "paypal/payment.html", context)
