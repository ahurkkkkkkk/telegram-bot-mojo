from std.testing import assert_equal, assert_raises

from telegram import BotDescription, BotName, BotShortDescription, MessageId
from telegram._utils.json import parse_json


def main() raises:
    var source = parse_json("{\"message_id\":7,\"future\":{\"ok\":true}}")
    var message = MessageId.de_json(source)
    assert_equal(message.message_id, 7)
    assert_equal(message.api_kwargs.nodes[message.api_kwargs.root].kind, 5)
    assert_equal(
        message.to_json(),
        "{\"message_id\": 7, \"future\": {\"ok\": true}}",
    )
    assert_equal(message == MessageId(7), True)
    assert_equal(message == MessageId(8), False)
    assert_equal(hash(message), hash(MessageId(7)))

    var list_data = parse_json("[{\"message_id\":1},{\"message_id\":2}]")
    var messages = MessageId.de_list(list_data, list_data.root)
    assert_equal(len(messages), 2)
    assert_equal(messages[0].message_id, 1)
    assert_equal(messages[1].message_id, 2)

    var bot_names_data = parse_json("[{\"name\":\"one\"},{\"name\":\"two\"}]")
    var bot_names = BotName.de_list(bot_names_data, bot_names_data.root)
    assert_equal(len(bot_names), 2)
    assert_equal(bot_names[1].name, "two")

    var descriptions_data = parse_json("[{\"description\":\"one\"},{\"description\":\"two\"}]")
    var descriptions = BotDescription.de_list(descriptions_data, descriptions_data.root)
    assert_equal(len(descriptions), 2)
    assert_equal(descriptions[1].description, "two")

    var shorts_data = parse_json("[{\"short_description\":\"one\"}]")
    var shorts = BotShortDescription.de_list(shorts_data, shorts_data.root)
    assert_equal(len(shorts), 1)
    assert_equal(shorts[0].short_description, "one")

    with assert_raises():
        _ = MessageId.de_json(parse_json("{\"other\":1}"))
    with assert_raises():
        _ = MessageId.de_json(parse_json("{\"message_id\":1.5}"))

    var bot = BotName.de_json(parse_json("{\"name\":\"native bot\",\"future\":3}"))
    assert_equal(bot.name, "native bot")
    assert_equal(BotName.MAX_LENGTH, 64)
    assert_equal(bot.to_json(), "{\"name\": \"native bot\", \"future\": 3}")
    assert_equal(bot == BotName("native bot"), True)
    assert_equal(bot == BotName("different"), False)
    assert_equal(hash(bot), hash(BotName("native bot")))

    var description = BotDescription.de_json(
        parse_json("{\"description\":\"a bot\",\"future\":false}")
    )
    assert_equal(description.description, "a bot")
    assert_equal(description.to_json(), "{\"description\": \"a bot\", \"future\": false}")
    assert_equal(description == BotDescription("a bot"), True)
    assert_equal(hash(description), hash(BotDescription("a bot")))

    var short_description = BotShortDescription.de_json(
        parse_json("{\"short_description\":\"short\"}")
    )
    assert_equal(short_description.short_description, "short")
    assert_equal(short_description.to_json(), "{\"short_description\": \"short\"}")
    assert_equal(hash(short_description), hash(BotShortDescription("short")))
