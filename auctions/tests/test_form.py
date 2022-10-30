from auctions.forms import MakeBetForms
from django.test import TestCase
from auctions.models import Auction, Category, Bid
from auctions.views import check_rate


class TestForms(TestCase):
    @classmethod
    def setUpTestData(cls):
        Bid.objects.create(auction=1, bid=100, author_bid="user")
        Category.objects.create(name="Home")
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

    def test_forms(self):
        form_data = {"bid": 500, "author_bid": "user"}
        form_data2 = {"bid": "value", "author_bid": "user"}
        form_data3 = {"bid": 1, "author_bid": "user"}
        form = MakeBetForms(data=form_data)
        form2 = MakeBetForms(data=form_data2)
        name_auction = "test_auction"
        self.assertIs(form.is_valid(), True)
        self.assertIs(check_rate(name_auction, form_data.get("bid")), True)
        self.assertIs(check_rate(name_auction, form_data3.get("bid")), False)
        self.assertIs(form2.is_valid(), False)
