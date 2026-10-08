from std.testing import assert_equal

from telegram import (
    ReactionCount,
    ReactionType,
    ReactionTypeCustomEmoji,
    ReactionTypeEmoji,
    ReactionTypePaid,
)
from telegram._utils.json import parse_json


def main() raises:
    var emoji = ReactionTypeEmoji("👍")
    assert_equal(emoji.type, ReactionType.EMOJI)
    assert_equal(
        emoji.to_json(),
        "{\"emoji\": \"\\ud83d\\udc4d\", \"type\": \"emoji\"}",
    )
    var emoji_copy = ReactionTypeEmoji.de_json(
        parse_json("{\"type\":\"emoji\",\"emoji\":\"👍\"}")
    )
    assert_equal(emoji_copy == emoji, True)
    assert_equal(hash(emoji_copy), hash(emoji))
    var tagged_emoji = ReactionType.de_json(parse_json(emoji.to_json()))
    assert_equal(tagged_emoji.type, ReactionType.EMOJI)
    assert_equal(tagged_emoji.has_variant, True)
    assert_equal(tagged_emoji.emoji, "👍")
    assert_equal(tagged_emoji.to_json(), emoji.to_json())

    var custom = ReactionTypeCustomEmoji("custom-id")
    var tagged_custom = ReactionType.de_json(parse_json(custom.to_json()))
    assert_equal(tagged_custom.custom_emoji_id, "custom-id")
    assert_equal(tagged_custom == ReactionType.de_json(parse_json(custom.to_json())), True)

    var paid = ReactionTypePaid()
    assert_equal(ReactionType.de_json(parse_json(paid.to_json())).type, ReactionType.PAID)

    var unknown = ReactionType.de_json(
        parse_json("{\"type\":\"future\",\"future_field\":true}")
    )
    assert_equal(unknown.has_variant, False)
    assert_equal(
        unknown.to_json(),
        "{\"type\": \"future\", \"future_field\": true}",
    )

    var count = ReactionCount(tagged_emoji, 4)
    var count_copy = ReactionCount.de_json(parse_json(count.to_json()))
    assert_equal(count_copy == count, True)
    assert_equal(hash(count_copy), hash(count))
    assert_equal(count_copy.type.emoji, "👍")
