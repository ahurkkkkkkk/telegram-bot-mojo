from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Update
from telegram.ext import PollHandler


def main() raises:
    var handler = PollHandler()
    assert_equal(handler.check_update(None), False)
    var no_update: Optional[Update] = None
    assert_equal(handler.check_update(no_update), False)

    var explicit_nonblocking = PollHandler(False)
    assert_equal(explicit_nonblocking.resolve_block(True), False)
