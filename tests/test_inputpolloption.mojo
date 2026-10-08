from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import InputPollOption, MessageEntity
from telegram._utils.json import parse_json


def main() raises:
    var entities = List[MessageEntity]()
    entities.append(MessageEntity("bold", 0, 4))
    var media_document = parse_json('{"type":"photo","media":"attach://photo"}')
    var option = InputPollOption(
        "Vote",
        Optional[String]("HTML"),
        entities,
        Optional(media_document.copy()),
    )
    assert_equal(option == InputPollOption("Vote"), True)
    var encoded = option.to_json()
    assert_equal(encoded, '{"text": "Vote", "text_parse_mode": "HTML", "text_entities": [{"length": 4, "offset": 0, "type": "bold"}], "media": {"type": "photo", "media": "attach://photo"}}')

    var decoded = InputPollOption.de_json(parse_json(encoded))
    assert_equal(decoded.text, "Vote")
    assert_equal(decoded.text_parse_mode.value(), "HTML")
    assert_equal(len(decoded.text_entities), 1)
    assert_equal(decoded.media is None, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "media") != -1, True)
    assert_equal(decoded.to_json(), encoded)
    assert_equal(len(InputPollOption.de_list(parse_json("[" + encoded + "]"), 0)), 1)
