from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import RevenueWithdrawalState
from telegram._utils.datetime import from_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var pending = RevenueWithdrawalState.pending()
    var failed = RevenueWithdrawalState.failed()
    assert_equal(pending.type, RevenueWithdrawalState.PENDING)
    assert_equal(pending.to_json(), "{\"type\": \"pending\"}")
    assert_equal(pending == RevenueWithdrawalState.pending(), True)
    assert_equal(pending == failed, False)

    var date = from_timestamp(1_700_000_000)
    var succeeded = RevenueWithdrawalState.succeeded(date, "https://t.me/transaction")
    assert_equal(succeeded.type, RevenueWithdrawalState.SUCCEEDED)
    assert_equal(
        succeeded == RevenueWithdrawalState.succeeded(date, "https://other.example/tx"),
        True,
    )
    assert_equal(
        hash(succeeded),
        hash(RevenueWithdrawalState.succeeded(date, "https://other.example/tx")),
    )

    var decoded = RevenueWithdrawalState.de_json(
        parse_json(
            "{\"type\":\"succeeded\",\"date\":1700000000,\"url\":\"https://t.me/transaction\",\"future\":true}"
        )
    )
    assert_equal(decoded.date.value().year, 2023)
    assert_equal(decoded.url.value(), "https://t.me/transaction")
    assert_equal(
        decoded.to_dict().boolean_value(
            decoded.to_dict().object_get(decoded.to_dict().root, "future")
        ),
        True,
    )

    var unknown = RevenueWithdrawalState.de_json(parse_json("{\"type\":\"future_state\"}"))
    assert_equal(unknown.type, "future_state")
    assert_equal(unknown.to_json(), "{\"type\": \"future_state\"}")
    assert_equal(
        len(
            RevenueWithdrawalState.de_list(
                parse_json("[{\"type\":\"pending\"},{\"type\":\"failed\"}]"), 0
            )
        ),
        2,
    )
    with assert_raises():
        _ = RevenueWithdrawalState.de_json(parse_json("{\"type\":\"succeeded\"}"))

