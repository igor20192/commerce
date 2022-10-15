from dataclasses import fields
from xml.etree.ElementInclude import include
from django import forms
from .models import Bid


class MakeBetForms(forms.ModelForm):
    class Meta:
        model = Bid
        exclude = ("date_bid", "author_bid")
