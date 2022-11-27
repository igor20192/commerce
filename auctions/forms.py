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
        exclude = ("commet", "price", "active", "author_auct")

    price = forms.IntegerField(min_value=0)


list_category = [(category.name, category.name) for category in Category.objects.all()]


"""class MakeAuction(forms.Form):
    name = forms.CharField(label="auction name", max_length=64)
    brief_descrip = forms.CharField(max_length=250)
    categor = forms.ChoiceField(
        widget=forms.RadioSelect(),
        choices=list_category,
        required=True,
    )
    product_name = forms.CharField(max_length=64)
    description = forms.CharField(widget=forms.Textarea())
    image = forms.ImageField(required=False)
    image1 = forms.ImageField(required=False)
    image2 = forms.ImageField(required=False)
    image3 = forms.ImageField(required=False)
    price = forms.IntegerField()"""
