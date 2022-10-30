from django.test import TestCase
from auctions.models import Auction, Bid, Category, Comments


class TestModels(TestCase):
    @classmethod
    def setUpTestData(cls) -> None:
        Bid.objects.create(auction=1, bid=100, author_bid="user")
        Category.objects.create(name="Home")
        Comments.objects.create(
            auction_name="test_auction", comments="comments", author_comments="user"
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

    def test_bid(self):
        obj = Bid.objects.get(bid=100)
        self.assertIsInstance(obj, Bid)
        self.assertEqual(obj.bid, 100)
        self.assertEqual(obj.author_bid, "user", "Not user error")
        self.assertEqual(obj.id, 1)
        label = obj._meta.get_field("bid").verbose_name
        self.assertEqual(label, "bid")

    def test_category(self):
        obj_category = Category.objects.get(name="Home")
        label = obj_category._meta.get_field("name").verbose_name
        self.assertIsInstance(obj_category, Category)
        self.assertEqual(obj_category.name, "Home")
        self.assertEqual(label, "name")

    def test_comments(self):
        comm = Comments.objects.get(auction_name="test_auction")
        self.assertIsInstance(comm, Comments)

    def test_auction(self):
        auc_obj = Auction.objects.get(name="test_auction")
        Comments.objects.create(
            auction_name="test_auction", comments="comments1", author_comments="user1"
        )
        comm = Comments.objects.filter(auction_name="test_auction")

        auc_obj.commet.set(comm)
        self.assertIsInstance(auc_obj, Auction)
        self.assertEqual(auc_obj.name, "test_auction")
        self.assertEqual(auc_obj.brief_descrip, "test")
        self.assertEqual(auc_obj.categor.name, "Home")
        self.assertEqual(auc_obj.author_auct, "user")
        self.assertEqual(auc_obj.description, "description")
        self.assertEqual(auc_obj.product_name, "product")
        self.assertTrue(auc_obj.active, True)
        self.assertEqual(auc_obj.price.bid, 100)
        self.assertEqual(auc_obj.price.author_bid, "user")
        self.assertEqual(
            auc_obj.commet.get(author_comments="user").comments, "comments"
        )
        self.assertEqual(
            auc_obj.commet.get(author_comments="user1").comments, "comments1"
        )
