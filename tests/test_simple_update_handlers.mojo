from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Update
from telegram.ext import (
    PollAnswerHandler,
    PreCheckoutQueryHandler,
    ShippingQueryHandler,
)


def main() raises:
    var no_update: Optional[Update] = None
    var poll_answer_handler = PollAnswerHandler()
    var pre_checkout_handler = PreCheckoutQueryHandler()
    var shipping_handler = ShippingQueryHandler()

    assert_equal(poll_answer_handler.check_update(no_update), False)
    assert_equal(pre_checkout_handler.check_update(no_update), False)
    assert_equal(shipping_handler.check_update(no_update), False)
    assert_equal(shipping_handler.resolve_block(True), True)

    var nonblocking = PreCheckoutQueryHandler(False)
    assert_equal(nonblocking.resolve_block(True), False)
