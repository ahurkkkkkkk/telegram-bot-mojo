from std.testing import assert_equal

from telegram import BotCommand
from telegram._utils.json import parse_json


def main() raises:
    var command = BotCommand.de_json(
        parse_json("{\"command\":\"start\",\"description\":\"Start me\",\"future\":9}")
    )
    assert_equal(command.command, "start")
    assert_equal(command.description, "Start me")
    assert_equal(command.to_json(), "{\"command\": \"start\", \"description\": \"Start me\", \"future\": 9}")
    assert_equal(command == BotCommand("start", "Start me"), True)
    assert_equal(hash(command), hash(BotCommand("start", "Start me")))
    assert_equal(command == BotCommand("stop", "Start me"), False)
    assert_equal(BotCommand.MIN_COMMAND, 1)
    assert_equal(BotCommand.MAX_COMMAND, 32)
    assert_equal(BotCommand.MIN_DESCRIPTION, 1)
    assert_equal(BotCommand.MAX_DESCRIPTION, 256)

    var commands_data = parse_json(
        "[{\"command\":\"start\",\"description\":\"Start me\"},{\"command\":\"help\",\"description\":\"Help\"}]"
    )
    var commands = BotCommand.de_list(commands_data, commands_data.root)
    assert_equal(len(commands), 2)
    assert_equal(commands[1].command, "help")
