from std.collections.optional import Optional
from std.testing import assert_equal

from telegram.ext import StringCommandHandler


def main() raises:
    var handler = StringCommandHandler("hello")
    assert_equal(handler.check_update(None) is None, True)
    assert_equal(handler.check_update(Optional[String]("hello")) is None, True)
    assert_equal(handler.check_update(Optional[String]("/helloworld")) is None, True)

    var command_only = handler.check_update(Optional[String]("/hello"))
    assert_equal(command_only is not None, True)
    assert_equal(len(command_only.value()), 0)

    var with_arguments = handler.check_update(Optional[String]("/hello one  three "))
    assert_equal(with_arguments is not None, True)
    var arguments = with_arguments.value().copy()
    assert_equal(len(arguments), 4)
    assert_equal(arguments[0], "one")
    assert_equal(arguments[1], "")
    assert_equal(arguments[2], "three")
    assert_equal(arguments[3], "")

    var explicit_block = StringCommandHandler("hello", False)
    assert_equal(explicit_block.resolve_block(True), False)
