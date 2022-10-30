from unicodedata import name
from urllib import response
from django.test import TestCase
from auctions.models import User, Auction, Bid, Category, Comments


# Create your tests here.
class TestViews(TestCase):
    def setUp(self) -> None:
        User.objects.create_user(username="user", password="7777")
        Category.objects.create(name="Home")
        Bid.objects.create(auction=1, bid=100, author_bid="user")
        Comments.objects.create(
            auction_name="test", comments="test", author_comments="test"
        )
        Auction.objects.create(
            name="test_auction",
            brief_descrip="test",
            product_name="product",
            description="description",
            image="auctions/static/img/Toys.png",
            author_auct="user",
            active=True,
            categor=Category.objects.get(name="Home"),
            price=Bid.objects.get(id=1),
        )

    URL = "/my_auction"

    def test_get_category(self):
        # not login user
        response = self.client.get("/category/Home")
        self.assertEqual(response.status_code, 302)
        # login user
        self.client.login(username="user", password="7777")
        response = self.client.get("/category/Home")
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "auctions/activ_auctions.html")
        self.assertEqual(response.context.get("category"), "Home")
        self.assertEqual(response.context.get("quantity"), 0)
        self.assertNotEqual(response.context.get("quantity"), 1)

    def test_add_auction(self, url=URL):
        self.client.get("/category/auction/add_auction/test_auction1")
        response = self.client.get("/category/auction/add_auction/test_auction2")
        session = self.client.session
        self.assertEqual(response.status_code, 302)
        self.assertEqual(session.get("my_auction"), ["test_auction1", "test_auction2"])
        self.assertEqual(response.url, url)

    def test_del_auction(self, url=URL):
        self.client.get("/category/auction/add_auction/test_auction12")
        session = self.client.session
        self.assertEqual(session.get("my_auction"), ["test_auction12"])
        response = self.client.get("/del_auction/test_auction12")
        session2 = self.client.session
        self.assertEqual(response.status_code, 302)
        self.assertEqual(session2.get("my_auction"), [])
        self.assertEqual(response.url, url)

    def test_my_auction(self, url=URL):
        response = self.client.get(url)
        self.assertRedirects(response, "/")
        self.client.get("/category/auction/add_auction/test_auction")
        response2 = self.client.get(url)
        self.assertTemplateUsed(response2, "auctions/my_auctions.html")
        self.assertEqual(response2.context["quantity"], 1)
        self.assertEqual(response2.context["auction"][0].name, "test_auction")

    def test_make_a_bet(self):
        self.client.login(username="user", password="7777")
        self.client.get("/category/auction/add_auction/test_auction")
        data = {"bid": 101, "author_bid": "user"}
        response = self.client.post("/category/auction/test_auction", data)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.context.get("quantity"), 1)
        self.assertTemplateUsed(response, "auctions/auction.html")
        self.assertEqual(response.context.get("auction").price.bid, 101)
        self.assertEqual(response.context.get("auction").price.author_bid, "user")
        data2 = {"bid": 99, "author_bid": "user"}
        response2 = self.client.post("/category/auction/test_auction", data2)
        self.assertEqual(response2.status_code, 200)
        self.assertContains(response2, "The bid must be greater than the current price")

    def test_close_the_auction(self):
        response = self.client.get("/close_the_auction/test_auction")
        self.assertEqual(response.status_code, 302)
        self.assertFalse(Auction.objects.get(name="test_auction").active)
        self.assertRedirects(response, "/")

    def test_close_auction_list(self):
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
        response = self.client.post("/comments/test_auction", {"comments": "comments"})
        self.assertEqual(response.status_code, 302)
        self.assertRedirects(response, "/category/auction/test_auction")
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
