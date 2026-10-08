from std.collections.optional import Optional
from std.testing import assert_equal

from telegram.ext import TypeHandler


def main() raises:
    var default_handler = TypeHandler[String]()
    var no_string: Optional[String] = None
    var some_string = Optional[String]("payload")
    assert_equal(default_handler.check_update(no_string), False)
    assert_equal(default_handler.check_update(some_string), True)
    assert_equal(default_handler.strict, False)
    assert_equal(default_handler.resolve_block(True), True)

    var strict_handler = TypeHandler[String](True, False)
    assert_equal(strict_handler.check_update(some_string), True)
    assert_equal(strict_handler.strict, True)
    assert_equal(strict_handler.resolve_block(True), False)
