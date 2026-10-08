#!/usr/bin/env mojo
#
# Derived from python-telegram-bot v22.8; LGPL-3.0-or-later. See LICENSE.

"""A Telegram dice or dart throw, including the rolled value."""

from telegram._telegramobject import TelegramJsonObject
from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct Dice(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A dice result; equality uses its value and emoji."""

    var value: Int
    var emoji: String
    var api_kwargs: JsonDocument

    comptime DICE = constants.DiceEmoji.DICE.value
    comptime DARTS = constants.DiceEmoji.DARTS.value
    comptime BASKETBALL = constants.DiceEmoji.BASKETBALL.value
    comptime FOOTBALL = constants.DiceEmoji.FOOTBALL.value
    comptime SLOT_MACHINE = constants.DiceEmoji.SLOT_MACHINE.value
    comptime BOWLING = constants.DiceEmoji.BOWLING.value
    comptime MIN_VALUE = constants.DiceLimit.MIN_VALUE.value
    comptime MAX_VALUE_BOWLING = constants.DiceLimit.MAX_VALUE_BOWLING.value
    comptime MAX_VALUE_DARTS = constants.DiceLimit.MAX_VALUE_DARTS.value
    comptime MAX_VALUE_DICE = constants.DiceLimit.MAX_VALUE_DICE.value
    comptime MAX_VALUE_BASKETBALL = constants.DiceLimit.MAX_VALUE_BASKETBALL.value
    comptime MAX_VALUE_FOOTBALL = constants.DiceLimit.MAX_VALUE_FOOTBALL.value
    comptime MAX_VALUE_SLOT_MACHINE = constants.DiceLimit.MAX_VALUE_SLOT_MACHINE.value

    def __init__(out self, value: Int, emoji: String):
        self.value = value
        self.emoji = emoji
        self.api_kwargs = empty_json_object()

    def __init__(out self, value: Int, emoji: String, api_kwargs: JsonDocument):
        self.value = value
        self.emoji = emoji
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.value = existing.value
        self.emoji = existing.emoji.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.value == other.value and self.emoji == other.emoji

    def __hash__[H: Hasher](self, mut hasher: H):
        var value_text = String(self.value)
        hasher.update(value_text.as_bytes())
        var separator = String("\0")
        hasher.update(separator.as_bytes())
        hasher.update(self.emoji.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "value", String(self.value))
        result.set_string(result.root, "emoji", self.emoji)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("Dice JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Dice JSON value is not an object")
        var value_index = data.object_get(data.root, "value")
        var emoji_index = data.object_get(data.root, "emoji")
        if value_index == -1 or emoji_index == -1:
            raise Error("Dice JSON object is missing a required field")
        var value = data.integer_value(value_index)
        var emoji = data.string_value(emoji_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "value" and key != "emoji":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Dice(value, emoji, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Dice.de_json(items[index].copy()))
        return result^
