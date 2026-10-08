from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import PrefixHandler, PrefixHandlerResult, filters


def _json_escape_text(text: String) -> String:
    var result = String()
    for character in text.codepoint_slices():
        if character == "\\":
            result.write_string("\\\\")
        elif character == "\"":
            result.write_string("\\\"")
        elif character == "\t":
            result.write_string("\\t")
        elif character == "\n":
            result.write_string("\\n")
        elif character == "\r":
            result.write_string("\\r")
        else:
            result.write_string(character)
    return result^


def _update(text: String, update_kind: String) raises -> Update:
    var event_key = "message"
    if update_kind == "channel_post":
        event_key = "channel_post"
    var json = String(
        '{"update_id":1,"', event_key,
        '":{"message_id":1,"date":1,"chat":{"id":10,"type":"private"},"text":"',
        _json_escape_text(text), '"}}'
    )
    return Update.de_json(parse_json(json))


def main() raises:
    var prefixes = List[String]()
    prefixes.append("!")
    prefixes.append("#")
    var commands = List[String]()
    commands.append("Test")
    commands.append("help")
    var handler = PrefixHandler(prefixes, commands)

    var update = _update("  !TEST\talpha\u2003beta  ", "message")
    var update_value = Optional[Update](update^)
    var result = handler.check_update(update_value)
    assert_equal(result.status, PrefixHandlerResult.MATCH)
    assert_equal(len(result.args), 2)
    assert_equal(result.args[0], "alpha")
    assert_equal(result.args[1], "beta")

    var mismatch = _update("?test alpha", "message")
    var mismatch_value = Optional[Update](mismatch^)
    assert_equal(
        handler.check_update(mismatch_value).status,
        PrefixHandlerResult.NO_MATCH,
    )

    var channel_post = _update("!test alpha", "channel_post")
    var channel_value = Optional[Update](channel_post^)
    var message_only_filter = Optional[filters.BaseFilter](filters.UpdateType.MESSAGE)
    var filtered = PrefixHandler(
        "!", "test", message_only_filter, False
    )
    assert_equal(filtered.check_update(channel_value).status, PrefixHandlerResult.FILTERED_OUT)
    assert_equal(filtered.resolve_block(True), False)

    var whitespace = _update("\t\u2003", "message")
    var whitespace_value = Optional[Update](whitespace^)
    with assert_raises():
        _ = handler.check_update(whitespace_value)
