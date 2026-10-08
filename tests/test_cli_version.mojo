from std.testing import assert_equal

from telegram.__main__ import format_ver_info


def main() raises:
    assert_equal(
        format_ver_info(),
        "python-telegram-bot 22.8\nBot API 10.0\nMojo native runtime",
    )
