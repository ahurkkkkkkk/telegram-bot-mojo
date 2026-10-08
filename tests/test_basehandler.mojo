from std.testing import assert_equal

from telegram._utils.defaultvalue import DEFAULT_TRUE
from telegram.ext import BaseHandler


def positive_update(update: Int) -> Bool:
    return update > 0


def add_context(
    context: Int, update: Int, application: Int, check_result: Bool
) -> Int:
    if check_result:
        return context + update + application
    return context


def main() raises:
    var handler = BaseHandler()
    assert_equal(handler.block.is_sentinel, True)
    assert_equal(handler.resolve_block(True), True)
    assert_equal(handler.resolve_block(False), False)

    var update = 7
    var check_result = handler.check_update(positive_update, update)
    assert_equal(check_result, True)

    var collected = handler.collect_context_with(
        add_context, 4, update, 10, check_result
    )
    assert_equal(collected, 21)
    assert_equal(handler.collect_additional_context(4, update, 10, check_result), 4)

    var explicit_block = BaseHandler(False)
    assert_equal(explicit_block.block.is_sentinel, False)
    assert_equal(explicit_block.resolve_block(True), False)
    assert_equal(explicit_block.resolve_block(False), False)

    var explicitly_defaulted = BaseHandler(DEFAULT_TRUE)
    assert_equal(explicitly_defaulted.block.is_sentinel, True)

    var negative = -1
    assert_equal(handler.check_update(positive_update, negative), False)
