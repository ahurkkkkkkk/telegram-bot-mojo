#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 InlineQueryResultGame.
# LGPL-3.0-or-later; see LICENSE.

"""An inline query result that launches a Telegram game."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._inline.inlinekeyboardmarkup import InlineKeyboardMarkup
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.constants import InlineQueryResultLimit, InlineQueryResultType


struct InlineQueryResultGame(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Game launch result; equality follows the inherited inline-result id identity."""

    comptime MIN_ID_LENGTH = InlineQueryResultLimit.MIN_ID_LENGTH.value
    comptime MAX_ID_LENGTH = InlineQueryResultLimit.MAX_ID_LENGTH.value

    var type: String
    var id: String
    var game_short_name: String
    var reply_markup: Optional[InlineKeyboardMarkup]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        game_short_name: String,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
    ):
        self.type = InlineQueryResultType.GAME.value.copy()
        self.id = id.copy()
        self.game_short_name = game_short_name.copy()
        self.reply_markup = reply_markup.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        game_short_name: String,
        reply_markup: Optional[InlineKeyboardMarkup] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = InlineQueryResultType.GAME.value.copy()
        self.id = id.copy()
        self.game_short_name = game_short_name.copy()
        self.reply_markup = reply_markup.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.id = existing.id.copy()
        self.game_short_name = existing.game_short_name.copy()
        self.reply_markup = existing.reply_markup.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("InlineQueryResultGame\0").as_bytes())
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "id", self.id)
        result.set_string(result.root, "game_short_name", self.game_short_name)
        if self.reply_markup is not None:
            var markup = self.reply_markup.value().to_dict(recursive)
            var index = result.copy_subtree_from(markup, markup.root)
            result.object_set(result.root, "reply_markup", index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultGame JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var name_index = data.object_get(data.root, "game_short_name")
        if id_index == -1 or name_index == -1:
            raise Error("InlineQueryResultGame JSON object is missing id or game_short_name")
        var markup: Optional[InlineKeyboardMarkup] = None
        var markup_index = data.object_get(data.root, "reply_markup")
        if markup_index != -1 and not data.is_null(markup_index):
            var markup_data = JsonDocument()
            markup_data.root = markup_data.copy_subtree_from(data, markup_index)
            markup = Optional[InlineKeyboardMarkup](InlineKeyboardMarkup.de_json(markup_data))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type" and key != "id" and key != "game_short_name" and key != "reply_markup":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResultGame(
            data.string_value(id_index), data.string_value(name_index), markup, api_kwargs=api_kwargs
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultGame.de_json(items[index].copy()))
        return result^
