from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import MessageEntity, ReplyParameters, TextQuote
from telegram._utils.json import parse_json


def main() raises:
    var entities = List[MessageEntity]()
    entities.append(MessageEntity("bold", 4, 4))
    var quote = TextQuote("A🚀 Bold", 12, entities, Optional[Bool](True))
    assert_equal(quote.parse_entity(entities[0]), "Bold")
    assert_equal(len(quote.parse_entities()), 1)
    var quote_json = quote.to_json()
    var decoded_quote = TextQuote.de_json(parse_json(quote_json))
    assert_equal(decoded_quote == quote, True)
    assert_equal(decoded_quote.is_manual.value(), True)
    assert_equal(decoded_quote.parse_entity(decoded_quote.entities[0]), "Bold")
    assert_equal(len(TextQuote.de_list(parse_json("[" + quote_json + "]"), 0)), 1)

    var parameters = ReplyParameters(17)
    parameters.set_chat_id_string("@updates")
    parameters.allow_sending_without_reply = Optional[Bool](False)
    parameters.quote = Optional[String]("A🚀 Bold")
    parameters.quote_parse_mode = Optional[String]("HTML")
    parameters.quote_entities = entities.copy()
    parameters.has_quote_entities = True
    parameters.quote_position = Optional[Int](12)
    parameters.checklist_task_id = Optional[Int](3)
    parameters.poll_option_id = Optional[String]("option-1")
    var parameters_json = parameters.to_json()
    var decoded_parameters = ReplyParameters.de_json(parse_json(parameters_json))
    assert_equal(decoded_parameters == parameters, True)
    assert_equal(decoded_parameters.chat_id_kind, 2)
    assert_equal(decoded_parameters.chat_id_string, "@updates")
    assert_equal(decoded_parameters.allow_sending_without_reply.value(), False)
    assert_equal(decoded_parameters.quote_entities[0] == entities[0], True)
    assert_equal(len(ReplyParameters.de_list(parse_json("[" + parameters_json + "]"), 0)), 1)

    var numeric_chat_id = ReplyParameters.de_json(
        parse_json('{"message_id":4,"chat_id":-100123,"future":true}')
    )
    assert_equal(numeric_chat_id.chat_id_kind, 1)
    assert_equal(numeric_chat_id.chat_id_number, -100123)
    assert_equal(numeric_chat_id.to_json(), '{"message_id": 4, "chat_id": -100123, "future": true}')
    with assert_raises():
        _ = ReplyParameters.de_json(parse_json("{}"))
