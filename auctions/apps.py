from django.apps import AppConfig
from paypal.standard.ipn.signals import valid_ipn_received


class AuctionsConfig(AppConfig):
    name = "auctions"

    def ready(self) -> None:
        from . import signals

        valid_ipn_received.connect(signals.show_me_the_money)
