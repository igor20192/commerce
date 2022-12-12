from django.test import TestCase
from auctions.models import User, Auction, Bid, Category, Comments
from auctions.views import exchange_rate_usd
from decimal import Decimal
import requests

# Create your tests here.
class TestViews(TestCase):
    def setUp(self) -> None:
        User.objects.create_user(username="user", password="7777")
        Category.objects.create(name="Toys")
        Bid.objects.create(auction=1, bid=100, author_bid="user")
        Comments.objects.create(
            auction_name="test", comments="test", author_comments="test"
        )
        for name in ("test_auction", "test_auction1", "test_auction2", "test_auction3"):
            Auction.objects.create(
                name=f"{name}",
                brief_descrip="test",
                product_name="product",
                description="description",
                author_auct="user",
                active=True,
                categor=Category.objects.get(name="Toys"),
                price=Bid.objects.get(id=1),
            )

    URL = "/my_auction"

    def test_get_category(self):
        # not login user
        response = self.client.get("/category/Toys")
        self.assertEqual(response.status_code, 302)
        # login user
        self.client.login(username="user", password="7777")
        response = self.client.get("/category/Toys")
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "auctions/activ_auctions.html")
        self.assertEqual(response.context.get("category"), "Toys")
        self.assertEqual(response.context.get("quantity"), 0)
        self.assertNotEqual(response.context.get("quantity"), 1)

    def test_add_auction(self, url=URL):
        self.client.login(username="user", password="7777")
        self.client.get("/category/auction/add_auction/test_auction1/Toys")
        response = self.client.get("/category/auction/add_auction/test_auction2/Toys")
        session = self.client.session
        self.assertEqual(response.status_code, 302)
        self.assertEqual(session.get("my_auction"), ["test_auction1", "test_auction2"])
        self.assertEqual(response.url, "/category/auction/test_auction2/Toys")

    def test_del_auction(self, url=URL):
        self.client.login(username="user", password="7777")
        self.client.get("/category/auction/add_auction/test_auction12/Toys")
        session = self.client.session
        self.assertEqual(session.get("my_auction"), ["test_auction12"])
        response = self.client.get("/del_auction/test_auction12/Toys")
        session2 = self.client.session
        self.assertEqual(response.status_code, 302)
        self.assertEqual(session2.get("my_auction"), [])
        self.assertEqual(response.url, "/category/auction/test_auction12/Toys")

    def test_my_auction(self, url=URL):
        self.client.login(username="user", password="7777")
        response = self.client.get(url)
        self.assertRedirects(response, "/")
        self.client.get("/category/auction/add_auction/test_auction/Toys")
        response2 = self.client.get(url)
        self.assertTemplateUsed(response2, "auctions/my_auctions.html")
        self.assertEqual(response2.context["quantity"], 1)
        self.assertEqual(response2.context["auction"][0].name, "test_auction")
        self.client.get("/category/auction/add_auction/test_auction1/Toys")
        self.client.get("/category/auction/add_auction/test_auction2/Toys")
        response3 = self.client.get(url)
        self.assertEqual(response3.context["quantity"], 3),
        self.assertEqual(
            [obj.name for obj in response3.context["auction"]],
            ["test_auction", "test_auction1", "test_auction2"],
        )
        self.client.get("/close_the_auction/test_auction2")
        response4 = self.client.get(url)
        self.assertEqual(response4.context["quantity"], 2)
        self.assertEqual(
            [obj.name for obj in response4.context["auction"]],
            ["test_auction", "test_auction1"],
        )
        self.assertTemplateUsed(response4, "auctions/my_auctions.html")

    def test_make_a_bet(self):
        self.client.login(username="user", password="7777")
        self.client.get("/category/auction/add_auction/test_auction/Toys")
        data = {"bid": 101, "author_bid": "user"}
        response = self.client.post("/category/auction/test_auction/Toys", data)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.context.get("quantity"), 1)
        self.assertTemplateUsed(response, "auctions/auction.html")
        self.assertEqual(response.context.get("success"), "Bet successfully placed!")
        self.assertEqual(response.context.get("auction").price.bid, 101)
        self.assertEqual(response.context.get("auction").price.author_bid, "user")
        data2 = {"bid": 99, "author_bid": "user"}
        response2 = self.client.post("/category/auction/test_auction/Toys", data2)
        self.assertEqual(response2.status_code, 200)
        self.assertEqual(
            response2.context.get("warning"),
            "The bid must be greater than the current price",
        )
        self.assertTemplateUsed(response2, "auctions/auction.html")

    def test_close_the_auction(self):
        self.client.login(username="user", password="7777")
        response = self.client.get("/close_the_auction/test_auction")
        self.assertEqual(response.status_code, 302)
        self.assertFalse(Auction.objects.get(name="test_auction").active)
        self.assertRedirects(response, "/close_auction")

    def test_close_auction_list(self):
        self.client.login(username="user", password="7777")
        self.client.get("/close_the_auction/test_auction")
        response = self.client.get("/close_auction")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            response.context.get("close_auction").get(name="test_auction").name,
            "test_auction",
        )
        self.assertEqual(response.context.get("quantity"), 0)
        self.assertTemplateUsed(response, "auctions/close_auction.html")

    def test_get_winner_auction(self):
        self.client.login(username="user", password="7777")
        response = self.client.get("/winner_auction/test_auction")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(str(response.context.get("winner")), "user")
        self.assertTemplateUsed(response, "auctions/winner_auction.html")

    def test_comments(self):
        self.client.login(username="user", password="7777")
        response = self.client.post(
            "/comments/test_auction/Toys", {"comments": "comments"}
        )
        self.assertEqual(response.status_code, 302)
        self.assertRedirects(response, "/category/auction/test_auction/Toys")
        comm = Comments.objects.filter(auction_name="test_auction")
        obj_auction = Auction.objects.get(name="test_auction")
        obj_auction.commet.set(comm)
        self.assertEqual(
            obj_auction.commet.get(auction_name="test_auction").comments, "comments"
        )
        self.assertEqual(
            obj_auction.commet.get(auction_name="test_auction").author_comments,
            "user",
        )

    def test_make_auction(self):
        self.client.login(username="user", password="7777")

        data = dict(
            name="test_auction4",
            brief_descrip="brief_descrip",
            categor="1",
            product_name="product_name",
            description="description",
            price=150,
        )
        response = self.client.post("/make_auction", data)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            Auction.objects.get(name="test_auction4").name, "test_auction4"
        ),
        self.assertEqual(Auction.objects.get(name="test_auction4").author_auct, "user"),
        self.assertEqual(Auction.objects.get(name="test_auction4").price.bid, 150),
        self.assertTemplateUsed(response, "auctions/auction.html")
        data["name"] = "test_auction"
        response = self.client.post("/make_auction", data)
        self.assertContains(
            response,
            "Check the entered data. Perhaps an auction with the same name already exists",
        )

    def test_exchange_rate_usd(self):
        self.assertIsInstance(exchange_rate_usd(), Decimal)
