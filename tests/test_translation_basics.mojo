from std.testing import assert_equal, assert_raises

from telegram._utils.defaultvalue import DEFAULT_FALSE, DEFAULT_NONE, DEFAULT_TRUE, DefaultValue, get_value, is_truthy
from telegram._utils.strings import TextEncoding, to_camel_case
from telegram._version import __version__, __version_info__, Version, version_info, version_string
from telegram import __bot_api_version__, __bot_api_version_info__


def main() raises:
    assert_equal(to_camel_case("set_webhook"), "setWebhook")
    assert_equal(to_camel_case("get_chat_member_count"), "getChatMemberCount")
    assert_equal(to_camel_case("some__api"), "someApi")
    assert_equal(to_camel_case("foo_1bar"), "foo1Bar")
    assert_equal(to_camel_case("foo_bar-baz"), "fooBar-Baz")
    assert_equal(to_camel_case("foo_o'NEIL"), "fooO'Neil")
    assert_equal(to_camel_case("foo_ßeta"), "fooSseta")
    assert_equal(to_camel_case("foo_ᾲTAIL"), "fooᾺͅtail")
    assert_equal(to_camel_case("foo_ǅABC"), "fooǅabc")
    assert_equal(TextEncoding.UTF_8.value, "utf-8")
    assert_equal(TextEncoding.UTF_8.name, "UTF_8")
    assert_equal(TextEncoding.UTF_8 == "utf-8", True)
    assert_equal(TextEncoding.UTF_16_LE.__repr__(), "<TextEncoding.UTF_16_LE>")
    assert_equal(TextEncoding("utf-8").name, "UTF_8")
    assert_equal(version_string(), "22.8")
    assert_equal(__bot_api_version__, "10.0")
    assert_equal(__bot_api_version_info__.major, 10)
    assert_equal(__version__, "22.8")

    var version = version_info()
    assert_equal(version.major, 22)
    assert_equal(version.minor, 8)
    assert_equal(version.micro, 0)
    assert_equal(version.releaselevel, "final")
    assert_equal(version.serial, 0)
    assert_equal(__version_info__.to_tuple(), (22, 8, 0, "final", 0))
    assert_equal(Version(22, 8, 1, "final", 0).__str__(), "22.8.1")
    assert_equal(Version(22, 8, 0, "alpha", 2).__str__(), "22.8a2")
    assert_equal(Version(22, 8, 0, "beta", 3).__str__(), "22.8b3")
    assert_equal(Version(22, 8, 0, "candidate", 4).__str__(), "22.8rc4")
    assert_equal(Version(22, 8, 0, "beta", 2) < Version(22, 8, 0, "final", 0), True)
    assert_equal(Version(22, 8, 1, "final", 0) > Version(22, 8, 0, "final", 0), True)
    assert_equal(Version(22, 8, 0, "final", 0) <= Version(22, 8, 0, "final", 0), True)
    with assert_raises():
        _ = Version(22, 8, 0, "unknown", 0).format()

    assert_equal(DEFAULT_FALSE.value, False)
    assert_equal(DEFAULT_TRUE.value, True)
    assert_equal(DEFAULT_NONE.is_sentinel, True)
    assert_equal(DEFAULT_FALSE.is_sentinel, True)
    var wrapped_true = DefaultValue(True, sentinel=True)
    assert_equal(get_value(wrapped_true), True)
    assert_equal(get_value(DEFAULT_TRUE), True)
    assert_equal(get_value(True), True)
    assert_equal(get_value(42), 42)
    assert_equal(get_value(1.5), 1.5)
    assert_equal(get_value("plain"), "plain")
    assert_equal(DefaultValue(False).unwrap(), False)
    assert_equal(is_truthy(wrapped_true), True)
    assert_equal(is_truthy(DefaultValue(False)), False)

    var explicit_false = DefaultValue(False)
    assert_equal(explicit_false.is_sentinel, False)
