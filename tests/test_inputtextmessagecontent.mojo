from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import InputTextMessageContent, LinkPreviewOptions, MessageEntity
from telegram._utils.json import parse_json


def main() raises:
    var entities = List[MessageEntity]()
    entities.append(MessageEntity(MessageEntity.BOLD, 0, 4))
    var content = InputTextMessageContent(
        "test",
        Optional[String]("HTML"),
        Optional[List[MessageEntity]](entities^),
        Optional[LinkPreviewOptions](LinkPreviewOptions(url="https://example.test")),
    )
    assert_equal(content.message_text, "test")
    assert_equal(len(content.entities), 1)
    assert_equal(content.entities[0].type, MessageEntity.BOLD)
    assert_equal(content.link_preview_options.value().url.value(), "https://example.test")
    assert_equal(
        content.to_json(),
        "{\"entities\": [{\"length\": 4, \"offset\": 0, \"type\": \"bold\"}], \"link_preview_options\": {\"url\": \"https://example.test\"}, \"message_text\": \"test\", \"parse_mode\": \"HTML\"}",
    )

    var decoded = InputTextMessageContent.de_json(
        parse_json(
            "{\"message_text\":\"test\",\"parse_mode\":\"HTML\",\"entities\":[{\"type\":\"bold\",\"offset\":0,\"length\":4}],\"link_preview_options\":{\"url\":\"https://example.test\"},\"future\":true}"
        )
    )
    assert_equal(decoded == content, True)
    assert_equal(hash(decoded), hash(content))
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(len(InputTextMessageContent.de_list(parse_json("[{\"message_text\":\"x\"}]"), 0)), 1)

    var disabled = InputTextMessageContent(
        "preview off", disable_web_page_preview=Optional[Bool](True)
    )
    assert_equal(disabled.link_preview_options.value().is_disabled.value(), True)
    var enabled = InputTextMessageContent(
        "preview on", disable_web_page_preview=Optional[Bool](False)
    )
    assert_equal(enabled.link_preview_options.value().is_disabled.value(), False)

    var conflict = False
    try:
        _ = InputTextMessageContent(
            "conflict",
            link_preview_options=Optional[LinkPreviewOptions](LinkPreviewOptions()),
            disable_web_page_preview=Optional[Bool](True),
        )
    except error:
        conflict = True
    assert_equal(conflict, True)

    assert_equal(InputTextMessageContent.MIN_TEXT_LENGTH, 1)
    assert_equal(InputTextMessageContent.MAX_TEXT_LENGTH, 4096)

    var custom = InputTextMessageContent(
        "custom", api_kwargs=parse_json("{\"future\":true}")
    )
    assert_equal(custom.api_kwargs.object_get(custom.api_kwargs.root, "future") != -1, True)
