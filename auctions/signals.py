from django.dispatch import receiver
from paypal.standard.models import ST_PP_COMPLETED
from paypal.standard.ipn.signals import valid_ipn_received
from .models import Auction
from django.shortcuts import get_object_or_404


@receiver(valid_ipn_received)
def show_me_the_money(sender, **kwargs):
    ipn_obj = sender
    if ipn_obj.payment_status == ST_PP_COMPLETED:
        # WARNING !
        # Check that the receiver email is the same we previously
        # set on the `business` field. (The user could tamper with
        # that fields on the payment form before it goes to PayPal)
        if ipn_obj.receiver_email != "sb-nel43b22326328@business.example.com":
            # Not a valid payment
            return

        auct = get_object_or_404(Auction, pk=ipn_obj.invoice)
        if ipn_obj.mc_gross == auct.price.bid and ipn_obj.mc_currency == "USD":
            auct.paid = True
            auct.save()
        else:
            raise ValueError("Paypal ipn_obj data not valid!")
