from std.collections.optional import Optional
from std.testing import assert_equal

from telegram.ext import StringRegexHandler


def main() raises:
    var handler = StringRegexHandler("^/hello(?:\\s|$)")
    assert_equal(handler.check_update(None) is None, True)
    assert_equal(handler.check_update(Optional[String]("other")) is None, True)
    assert_equal(handler.check_update(Optional[String]("/helloworld")) is None, True)
    assert_equal(
        handler.check_update(Optional[String]("/hello there")) is not None,
        True,
    )

    var unicode_handler = StringRegexHandler("^\\d+$")
    assert_equal(
        unicode_handler.check_update(Optional[String]("٤٢")) is not None,
        True,
    )
    var explicit_block = StringRegexHandler(".*", False)
    assert_equal(explicit_block.resolve_block(True), False)
