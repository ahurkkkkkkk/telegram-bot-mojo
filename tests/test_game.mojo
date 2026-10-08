from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Game, MessageEntity, PhotoSize
from telegram._utils.json import parse_json


def main() raises:
    var photo = List[PhotoSize]()
    photo.append(PhotoSize("file", "unique", 320, 240))
    var entities = List[MessageEntity]()
    entities.append(MessageEntity("bold", 3, 4))
    var game = Game(
        "Chess",
        "A game",
        photo,
        Optional[String]("A🚀Game"),
        entities,
        None,
    )
    assert_equal(game.parse_text_entity(entities[0]), "Game")
    assert_equal(len(game.parse_text_entities()), 1)
    var encoded = game.to_json()
    var decoded = Game.de_json(parse_json(encoded))
    assert_equal(decoded == game, True)
    assert_equal(decoded.text.value(), "A🚀Game")
    assert_equal(decoded.photo[0].file_unique_id, "unique")
    assert_equal(len(Game.de_list(parse_json("[" + encoded + "]"), 0)), 1)
    assert_equal(game == Game("Chess", "A game", photo), True)

    var future = Game.de_json(
        parse_json('{"title":"T","description":"D","photo":[],"future":1}')
    )
    assert_equal(future.to_json(), '{"title": "T", "description": "D", "photo": [], "future": 1}')
    with assert_raises():
        _ = Game.de_json(parse_json('{"title":"missing fields"}'))
