from std.testing import assert_equal
from telegram.constants import (
    AccentColor,
    BOT_API_VERSION,
    BOT_API_VERSION_INFO,
    BotCommandLimit,
    ChatAction,
    ChatType,
    Nanostar,
    ProfileAccentColor,
    SUPPORTED_WEBHOOK_PORTS,
    ZERO_DATE,
)


def main() raises:
    assert_equal(BOT_API_VERSION, "10.0")
    assert_equal(BOT_API_VERSION_INFO.major, 10)
    assert_equal(BOT_API_VERSION_INFO.minor, 0)
    assert_equal(BOT_API_VERSION_INFO.__str__(), "10.0")

    var group = ChatType.GROUP
    assert_equal(group.value, "group")
    assert_equal(group.name, "GROUP")
    assert_equal(group == "group", True)
    var parsed_group = ChatType("group")
    assert_equal(parsed_group.name, "GROUP")
    assert_equal(String(ChatAction.TYPING.value), "typing")
    assert_equal(ChatType.SUPERGROUP.name, "SUPERGROUP")

    var command_limit = BotCommandLimit.MAX_COMMAND
    assert_equal(command_limit.value, 32)
    assert_equal(command_limit.name, "MAX_COMMAND")
    var parsed_limit = BotCommandLimit(32)
    assert_equal(parsed_limit.name, "MAX_COMMAND")
    assert_equal(Int(Nanostar.VALUE.value * 1000000000.0), 1)
    var parsed_nanostar = Nanostar(1.0 / 1000000000.0)
    assert_equal(parsed_nanostar.name, "VALUE")

    var accent = AccentColor.COLOR_007.value
    assert_equal(accent.identifier, 7)
    assert_equal(accent.has_name, False)
    assert_equal(accent.light_colors.count, 2)
    assert_equal(accent.light_colors.at(0), 14766162)
    assert_equal(accent.dark_colors.at(1), 10039095)

    var profile = ProfileAccentColor.COLOR_008.value
    assert_equal(profile.identifier, 8)
    assert_equal(profile.light_colors.count, 2)
    assert_equal(profile.dark_colors.at(1), 11294782)

    assert_equal(SUPPORTED_WEBHOOK_PORTS[0], 443)
    assert_equal(SUPPORTED_WEBHOOK_PORTS[3], 8443)
    assert_equal(ZERO_DATE.year, 1970)
    assert_equal(ZERO_DATE.month, 1)
    assert_equal(ZERO_DATE.utc_offset_seconds, 0)
