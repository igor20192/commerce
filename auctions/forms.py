from dataclasses import fields
from pyexpat import model
from xml.etree.ElementInclude import include
from django import forms
from .models import Bid, Comments


class MakeBetForms(forms.ModelForm):
    class Meta:
        model = Bid
        exclude = ("date_bid", "author_bid")


class CommentsForm(forms.ModelForm):
    class Meta:
        model = Comments
        fields = ["comments"]
