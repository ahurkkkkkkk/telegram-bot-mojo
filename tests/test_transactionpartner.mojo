from std.testing import assert_equal

from telegram import TransactionPartnerTelegramApi
from telegram._utils.json import parse_json


def main() raises:
    var partner = TransactionPartnerTelegramApi(7)
    assert_equal(partner.TYPE, "telegram_api")
    assert_equal(
        partner.to_json(),
        "{\"type\": \"telegram_api\", \"request_count\": 7}",
    )
    var decoded = TransactionPartnerTelegramApi.de_json(
        parse_json("{\"request_count\":7,\"future\":true}")
    )
    assert_equal(decoded == partner, True)
    assert_equal(
        decoded.to_json(),
        "{\"type\": \"telegram_api\", \"request_count\": 7, \"future\": true}",
    )
