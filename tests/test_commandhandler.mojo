from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Update
from telegram._utils.json import parse_json
from telegram.ext import CommandHandler, CommandHandlerResult, filters


def _update(text: String, entity_type: String, entity_offset: Int, entity_length: Int) raises -> Update:
    var escaped = String()
    for character in text.codepoint_slices():
        if character == "\\":
            escaped.write_string("\\\\")
        elif character == "\"":
            escaped.write_string("\\\"")
        elif character == "\t":
            escaped.write_string("\\t")
        elif character == "\n":
            escaped.write_string("\\n")
        elif character == "\r":
            escaped.write_string("\\r")
        else:
            escaped.write_string(character)
    var json = String(
        '{"update_id":1,"message":{"message_id":1,"date":1,'
        '"chat":{"id":10,"type":"private"},"text":"', escaped,
        '","entities":[{"type":"', entity_type,
        '","offset":', entity_offset, ',"length":', entity_length, '}]}}'
    )
    return Update.de_json(parse_json(json))


def main() raises:
    var handler = CommandHandler("StArT", Optional[String]("MyBot"))
    var normal_update = _update("/START one\ttwo\u2003three", "bot_command", 0, 6)
    var normal_value = Optional[Update](normal_update^)
    var normal_result = handler.check_update(normal_value)
    assert_equal(normal_result.status, CommandHandlerResult.MATCH)
    assert_equal(len(normal_result.args), 3)
    assert_equal(normal_result.args[0], "one")
    assert_equal(normal_result.args[1], "two")
    assert_equal(normal_result.args[2], "three")

    var addressed_update = _update("/start@MYBOT arg", "bot_command", 0, 12)
    var addressed_value = Optional[Update](addressed_update^)
    assert_equal(handler.check_update(addressed_value).status, CommandHandlerResult.MATCH)

    var wrong_bot_update = _update("/start@other arg", "bot_command", 0, 12)
    var wrong_bot_value = Optional[Update](wrong_bot_update^)
    assert_equal(handler.check_update(wrong_bot_value).status, CommandHandlerResult.NO_MATCH)

    var wrong_entity_update = _update("/start arg", "bold", 0, 6)
    var wrong_entity_value = Optional[Update](wrong_entity_update^)
    assert_equal(handler.check_update(wrong_entity_value).status, CommandHandlerResult.NO_MATCH)

    var args_required = CommandHandler(
        "start", Optional[String]("mybot"), None, True
    )
    assert_equal(args_required.check_update(normal_value).status, CommandHandlerResult.MATCH)
    var no_arg_update = _update("/start", "bot_command", 0, 6)
    var no_arg_value = Optional[Update](no_arg_update^)
    assert_equal(args_required.check_update(no_arg_value).status, CommandHandlerResult.NO_MATCH)

    var exact_args = CommandHandler(
        "start", Optional[String]("mybot"), None, Optional[Int](3)
    )
    assert_equal(exact_args.check_update(normal_value).status, CommandHandlerResult.MATCH)
    var exact_two = CommandHandler(
        "start", Optional[String]("mybot"), None, Optional[Int](2)
    )
    assert_equal(exact_two.check_update(normal_value).status, CommandHandlerResult.NO_MATCH)

    var filtered = CommandHandler(
        "start", Optional[String]("mybot"),
        Optional[filters.BaseFilter](filters.UpdateType.EDITED_MESSAGE)
    )
    assert_equal(filtered.check_update(normal_value).status, CommandHandlerResult.FILTERED_OUT)

    var nonblocking = CommandHandler("start", Optional[String]("mybot"), None, None, False)
    assert_equal(nonblocking.resolve_block(True), False)

    var command_names = List[String]()
    command_names.append("start")
    command_names.append("help")
    var multiple = CommandHandler(command_names, Optional[String]("mybot"))
    var help_update = _update("/HELP", "bot_command", 0, 5)
    var help_value = Optional[Update](help_update^)
    assert_equal(multiple.check_update(help_value).status, CommandHandlerResult.MATCH)

    var unicode_decimal = CommandHandler("٤٢", Optional[String]("mybot"))
    var unicode_command_update = _update("/٤٢ arg", "bot_command", 0, 3)
    var unicode_command_value = Optional[Update](unicode_command_update^)
    assert_equal(
        unicode_decimal.check_update(unicode_command_value).status,
        CommandHandlerResult.MATCH,
    )

    with assert_raises():
        var invalid = CommandHandler("bad-command", Optional[String]("mybot"))
    with assert_raises():
        var negative = CommandHandler(
            "start", Optional[String]("mybot"), None, Optional[Int](-1)
        )
