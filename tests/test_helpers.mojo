from std.testing import assert_equal

from telegram.helpers import (
    create_deep_linked_url,
    escape_markdown,
    mention_html,
    mention_markdown,
)


def main() raises:
    assert_equal(escape_markdown("a_b[c]"), "a\\_b\\[c]")
    assert_equal(escape_markdown("a_b.[x]", 2), "a\\_b\\.\\[x\\]")
    assert_equal(escape_markdown("a`b", 2, "code"), "a\\`b")
    assert_equal(escape_markdown("a)b", 2, "text_link"), "a\\)b")
    assert_equal(mention_html(42, "A&B <C> \"D\""), "<a href=\"tg://user?id=42\">A&amp;B &lt;C&gt; &quot;D&quot;</a>")
    assert_equal(mention_markdown("42", "A_B"), "[A_B](tg://user?id=42)")
    assert_equal(mention_markdown(42, "A_B", 2), "[A\\_B](tg://user?id=42)")
    assert_equal(create_deep_linked_url("sample_bot"), "https://t.me/sample_bot")
    assert_equal(
        create_deep_linked_url("sample_bot", "a_b-2", True),
        "https://t.me/sample_bot?startgroup=a_b-2",
    )
