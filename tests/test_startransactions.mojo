from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import StarTransaction, StarTransactions, TransactionPartner
from telegram._utils.datetime import from_timestamp
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, parse_json


def main() raises:
    var partner = TransactionPartner.telegram_api(7)
    var transaction = StarTransaction(
        "transaction-1",
        500,
        from_timestamp(1_700_000_000),
        Optional(partner.copy()),
        nanostar_amount=Optional[Int](12),
    )
    assert_equal(transaction.id, "transaction-1")
    assert_equal(transaction.amount, 500)
    assert_equal(transaction.date.year, 2023)
    assert_equal(transaction.source is not None, True)
    assert_equal(transaction.nanostar_amount.value(), 12)
    var transaction_json = transaction.to_dict()
    var source_index = transaction_json.object_get(transaction_json.root, "source")
    assert_equal(transaction_json.nodes[source_index].kind, JSON_OBJECT)
    assert_equal(transaction_json.string_value(transaction_json.object_get(source_index, "type")), "telegram_api")
    assert_equal(transaction_json.integer_value(transaction_json.object_get(source_index, "request_count")), 7)

    var decoded = StarTransaction.de_json(
        parse_json(
            "{\"id\":\"transaction-1\",\"amount\":500,\"date\":1700000000,\"source\":{\"type\":\"telegram_api\",\"request_count\":7},\"nanostar_amount\":12,\"future\":\"kept\"}"
        )
    )
    assert_equal(decoded == transaction, True)
    assert_equal(hash(decoded), hash(transaction))
    assert_equal(decoded.source.value().type, "telegram_api")
    var decoded_json = decoded.to_dict()
    assert_equal(decoded_json.string_value(decoded_json.object_get(decoded_json.root, "future")), "kept")

    var other_partner = TransactionPartner.telegram_api(8)
    var distinct = StarTransaction(
        "transaction-1",
        500,
        from_timestamp(1_700_000_000),
        Optional(other_partner.copy()),
    )
    assert_equal(transaction == distinct, False)

    var rows = List[StarTransaction]()
    rows.append(transaction.copy())
    var history = StarTransactions(rows)
    var history_json = history.to_dict()
    assert_equal(history_json.nodes[history_json.object_get(history_json.root, "transactions")].kind, JSON_ARRAY)
    var decoded_history = StarTransactions.de_json(
        parse_json(
            "{\"transactions\":[{\"id\":\"transaction-1\",\"amount\":500,\"date\":1700000000,\"source\":{\"type\":\"telegram_api\",\"request_count\":7}}],\"future\":true}"
        )
    )
    assert_equal(len(decoded_history.transactions), 1)
    assert_equal(decoded_history.transactions[0] == transaction, True)
    assert_equal(decoded_history.to_dict().boolean_value(decoded_history.to_dict().object_get(decoded_history.to_dict().root, "future")), True)
    assert_equal(len(StarTransactions.de_list(parse_json("[{\"transactions\":[]}]"), 0)), 1)
    assert_equal(StarTransactions(List[StarTransaction]()).to_dict().object_get(StarTransactions(List[StarTransaction]()).to_dict().root, "transactions"), -1)
    with assert_raises():
        _ = StarTransaction.de_json(parse_json("{}"))
