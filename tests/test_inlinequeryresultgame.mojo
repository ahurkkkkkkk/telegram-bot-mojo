from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import InlineKeyboardButton, InlineKeyboardMarkup, InlineQueryResult, InlineQueryResultGame
from telegram._utils.json import parse_json


def main() raises:
    var markup = InlineKeyboardMarkup.from_button(InlineKeyboardButton("play"))
    var game = InlineQueryResultGame("unique", "short-game", Optional[InlineKeyboardMarkup](markup.copy()))
    assert_equal(game.type, "game")
    assert_equal(game.id, "unique")
    assert_equal(game.game_short_name, "short-game")
    assert_equal(game.reply_markup.value() == markup, True)
    assert_equal(game.to_dict().object_get(game.to_dict().root, "reply_markup") != -1, True)

    var decoded = InlineQueryResultGame.de_json(
        parse_json(
            '{"type":"game","id":"unique","game_short_name":"short-game","reply_markup":{"inline_keyboard":[[{"text":"play"}]]},"future":{"x":1}}'
        )
    )
    assert_equal(decoded == game, True)
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "future") != -1, True)
    assert_equal(len(InlineQueryResultGame.de_list(parse_json('[{"id":"a","game_short_name":"b"}]'), 0)), 1)

    var base = InlineQueryResult("game", "id")
    assert_equal(base.type, "game")
    assert_equal(base.id, "id")
    assert_equal(InlineQueryResult.MIN_ID_LENGTH, 1)
    assert_equal(InlineQueryResult.MAX_ID_LENGTH, 64)
    assert_equal(InlineQueryResultGame("unique", "other") == game, True)
    with assert_raises():
        _ = InlineQueryResultGame.de_json(parse_json('{"id":"missing-name"}'))
