from dataclasses import fields
from pyexpat import model
from xml.etree.ElementInclude import include
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


list_category = [(category.name, category.name) for category in Category.objects.all()]


class MakeAuction(forms.Form):
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
    price = forms.IntegerField()
