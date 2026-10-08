from std.testing import assert_equal

from telegram._utils.usernames import get_full_name, get_link, get_name


def main() raises:
    assert_equal(get_full_name("Ada", "Lovelace").value(), "Ada Lovelace")
    assert_equal(get_full_name("Ada", None).value(), "Ada")
    assert_equal(get_full_name(None, "Lovelace") is None, True)
    assert_equal(get_full_name("", "Lovelace") is None, True)
    assert_equal(get_name("ada", "Ada", "Lovelace").value(), "@ada")
    assert_equal(get_name(None, "Ada", "Lovelace").value(), "Ada Lovelace")
    assert_equal(get_name("", "Ada", None).value(), "Ada")
    assert_equal(get_link("ada").value(), "https://t.me/ada")
    assert_equal(get_link("") is None, True)
    assert_equal(get_link(None) is None, True)
