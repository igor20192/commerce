from django.dispatch import receiver
from paypal.standard.models import ST_PP_COMPLETED
from paypal.standard.ipn.signals import valid_ipn_received
from .models import Auction, Transaction
from .views import exchange_rate_usd
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from decimal import Decimal


def my_transaction(obj):
    try:
        Transaction.objects.create(
            payment_date=obj.payment_date,
            receiver_email=obj.receiver_email,
            txn_id=obj.txn_id,
            test_ipn=obj.test_ipn,
            item_name=obj.item_name,
            auth_amount=obj.mc_gross,
            mc_currency=obj.mc_currency,
            address_country=obj.address_country,
            address_city=obj.address_city,
            address_name=obj.address_name,
            address_street=obj.address_street,
            address_zip=obj.address_zip,
            first_name=obj.first_name,
            last_name=obj.last_name,
            contact_phone=obj.contact_phone,
            payer_email=obj.payer_email,
        )
    except Exception as exc:
        raise ValidationError(exc.__doc__)


@receiver(valid_ipn_received)
def show_me_the_money(sender, **kwargs):
    ipn_obj = sender
    if ipn_obj.payment_status == ST_PP_COMPLETED:

        if ipn_obj.receiver_email != "sb-nel43b22326328@business.example.com":
            # Not a valid payment
            return

        auct = get_object_or_404(Auction, pk=ipn_obj.invoice)

        if (
            ipn_obj.mc_gross == round(Decimal(auct.price.bid) / exchange_rate_usd(), 2)
            and ipn_obj.mc_currency == "USD"
        ):
            my_transaction(ipn_obj)
            auct.paid = True
            auct.save()

        else:
            raise ValueError("Paypal ipn_obj data not valid!")
