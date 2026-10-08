from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InputInvoiceMessageContent, LabeledPrice
from telegram._utils.json import parse_json


def main() raises:
    var prices = List[LabeledPrice]()
    prices.append(LabeledPrice("Product", 1200))
    var tips = List[Int]()
    tips.append(100)
    tips.append(200)
    var invoice = InputInvoiceMessageContent(
        "Book",
        "A book",
        "payload-1",
        "USD",
        prices,
        Optional[String]("provider-token"),
        Optional[Int](500),
        Optional[List[Int]](tips.copy()),
        Optional[String]("{\"order\":1}"),
        Optional[String]("https://example.test/book.jpg"),
        Optional[Int](1024),
        Optional[Int](640),
        Optional[Int](480),
        Optional[Bool](False),
        Optional[Bool](True),
        Optional[Bool](False),
        Optional[Bool](True),
        Optional[Bool](False),
        Optional[Bool](True),
        Optional[Bool](False),
    )
    assert_equal(invoice.title, "Book")
    assert_equal(len(invoice.prices), 1)
    assert_equal(invoice.prices[0].amount, 1200)
    assert_equal(invoice.suggested_tip_amounts[1], 200)
    assert_equal(invoice.need_name.value(), False)

    var decoded = InputInvoiceMessageContent.de_json(
        parse_json(
            "{\"title\":\"Book\",\"description\":\"A book\",\"payload\":\"payload-1\",\"currency\":\"USD\",\"prices\":[{\"label\":\"Product\",\"amount\":1200}],\"suggested_tip_amounts\":[100,200],\"need_name\":false,\"is_flexible\":true,\"future\":{\"enabled\":true}}"
        )
    )
    assert_equal(decoded.currency, "USD")
    assert_equal(decoded.max_tip_amount is None, True)
    assert_equal(decoded.need_name.value(), False)
    assert_equal(decoded.is_flexible.value(), True)
    assert_equal(len(decoded.suggested_tip_amounts), 2)
    assert_equal(
        decoded.to_json(),
        "{\"currency\": \"USD\", \"description\": \"A book\", \"is_flexible\": true, \"need_name\": false, \"payload\": \"payload-1\", \"prices\": [{\"amount\": 1200, \"label\": \"Product\"}], \"suggested_tip_amounts\": [100, 200], \"title\": \"Book\", \"future\": {\"enabled\": true}}",
    )
    assert_equal(
        decoded == InputInvoiceMessageContent("Book", "A book", "payload-1", "USD", prices),
        True,
    )
    assert_equal(
        hash(decoded),
        hash(InputInvoiceMessageContent("Book", "A book", "payload-1", "USD", prices)),
    )

    var empty = InputInvoiceMessageContent.de_json(
        parse_json("{\"title\":\"T\",\"description\":\"D\",\"payload\":\"P\",\"currency\":\"XTR\",\"prices\":[]}")
    )
    assert_equal(empty.to_json(), "{\"currency\": \"XTR\", \"description\": \"D\", \"payload\": \"P\", \"title\": \"T\"}")
    with assert_raises():
        _ = InputInvoiceMessageContent.de_json(
            parse_json("{\"title\":\"T\",\"description\":\"D\",\"payload\":\"P\",\"currency\":\"USD\"}")
        )
