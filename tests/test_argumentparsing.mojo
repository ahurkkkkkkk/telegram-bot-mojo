from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import BotCommand
from telegram._utils.argumentparsing import (
    de_json_optional,
    de_list_optional,
    parse_sequence_arg,
)
from telegram._utils.json import JsonDocument, parse_json


def main() raises:
    var names: List[String] = ["first", "second"]
    var names_copy = parse_sequence_arg(names)
    assert_equal(len(names_copy), 2)
    assert_equal(names_copy[0], "first")

    var no_names = parse_sequence_arg(Optional[List[String]](None))
    assert_equal(len(no_names), 0)

    var no_object = de_json_optional[BotCommand](Optional[JsonDocument](None))
    assert_equal(no_object is None, True)
    var command_data = Optional[JsonDocument](
        parse_json("{\"command\":\"start\",\"description\":\"Run\"}")
    )
    var command = de_json_optional[BotCommand](command_data)
    assert_equal(command.value().command, "start")

    var no_array = de_list_optional[BotCommand](Optional[JsonDocument](None))
    assert_equal(len(no_array), 0)
    var commands_data = Optional[JsonDocument](
        parse_json(
            "[{\"command\":\"start\",\"description\":\"Run\"},{\"command\":\"stop\",\"description\":\"Halt\"}]"
        )
    )
    var commands = de_list_optional[BotCommand](commands_data)
    assert_equal(len(commands), 2)
    assert_equal(commands[1].command, "stop")
