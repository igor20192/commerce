from django import forms
from .models import Bid, Comments, Auction, Category


class MakeBetForms(forms.ModelForm):
    class Meta:
        model = Bid
        exclude = ("date_bid", "author_bid")


class CommentsForm(forms.ModelForm):
    class Meta:
        model = Comments
        fields = ["comments"]


class MakeAuction(forms.ModelForm):
    class Meta:
        model = Auction
        exclude = ("commet", "price", "active", "author_auct", "paid")

    price = forms.IntegerField(min_value=0)


list_category = [(category.name, category.name) for category in Category.objects.all()]
