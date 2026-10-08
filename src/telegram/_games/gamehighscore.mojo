#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 GameHighScore.
# LGPL-3.0-or-later; see LICENSE.

"""One user and score row in a Telegram game leaderboard."""

from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct GameHighScore(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A leaderboard row, equal by position, user ID, and score."""

    var position: Int
    var user: User
    var score: Int
    var api_kwargs: JsonDocument

    def __init__(out self, position: Int, user: User, score: Int):
        self.position = position
        self.user = user.copy()
        self.score = score
        self.api_kwargs = empty_json_object()

    def __init__(out self, position: Int, user: User, score: Int, *, api_kwargs: JsonDocument):
        self.position = position
        self.user = user.copy()
        self.score = score
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.position = existing.position
        self.user = existing.user.copy()
        self.score = existing.score
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.position == other.position and self.user == other.user and self.score == other.score

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.position).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.user.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.score).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "position", String(self.position))
        var user = self.user.to_dict(recursive=recursive)
        var user_node = result.copy_subtree_from(user, user.root)
        result.object_set(result.root, "user", user_node)
        result.set_number(result.root, "score", String(self.score))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("GameHighScore JSON value is not an object")
        var position_index = data.object_get(data.root, "position")
        var user_index = data.object_get(data.root, "user")
        var score_index = data.object_get(data.root, "score")
        if position_index == -1 or user_index == -1 or score_index == -1:
            raise Error("GameHighScore JSON object is missing a required field")
        var position = data.integer_value(position_index)
        var user_document = JsonDocument()
        user_document.root = user_document.copy_subtree_from(data, user_index)
        var user = User.de_json(user_document)
        var score = data.integer_value(score_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "position" and key != "user" and key != "score":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return GameHighScore(position, user, score, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(GameHighScore.de_json(items[index].copy()))
        return result^
