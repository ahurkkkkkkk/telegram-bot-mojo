from std.testing import assert_equal

from telegram import EncryptedCredentials, Invoice, LabeledPrice, ShippingAddress
from telegram._utils.json import parse_json


def main() raises:
    var invoice = Invoice("title", "description", "start", "USD", 120)
    var invoice_decoded = Invoice.de_json(parse_json(invoice.to_json()))
    assert_equal(invoice_decoded == invoice, True)
    assert_equal(invoice_decoded.total_amount, 120)

    var price = LabeledPrice("item", 250)
    var price_decoded = LabeledPrice.de_json(parse_json(price.to_json()))
    assert_equal(price_decoded == price, True)
    assert_equal(price_decoded.label, "item")

    var address = ShippingAddress("US", "CA", "Oakland", "1 Main", "Unit 2", "94607")
    var address_decoded = ShippingAddress.de_json(parse_json(address.to_json()))
    assert_equal(address_decoded == address, True)
    assert_equal(address_decoded.country_code, "US")
    assert_equal(address_decoded.post_code, "94607")

    var credentials = EncryptedCredentials("data", "hash", "secret")
    var credentials_decoded = EncryptedCredentials.de_json(parse_json(credentials.to_json()))
    assert_equal(credentials_decoded == credentials, True)
    assert_equal(credentials_decoded.secret, "secret")
