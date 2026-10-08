#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _uniquegift.py."""

from std.collections import List
from std.collections.optional import Optional

from telegram._chat import Chat
from telegram._files.sticker import Sticker
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _unique_gift_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


def _unique_gift_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _unique_gift_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _unique_gift_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


def _unique_gift_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _unique_gift_array(data: JsonDocument, index: Int) raises -> List[Int]:
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error("UniqueGiftColors color list must be an array")
    var result = List[Int]()
    var child = data.nodes[index].first_child
    while child != -1:
        result.append(data.integer_value(child))
        child = data.nodes[child].next_sibling
    return result^


def _unique_int_lists_equal(left: List[Int], right: List[Int]) -> Bool:
    if len(left) != len(right):
        return False
    for index in range(len(left)):
        if left[index] != right[index]:
            return False
    return True


def _unique_api_kwargs(data: JsonDocument, known: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var is_known = False
        for key in known:
            if key == data.nodes[child].name:
                is_known = True
                break
        if not is_known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, data.nodes[child].name.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct UniqueGiftColors(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Color palette for unique-gift names, replies, and link previews."""

    var model_custom_emoji_id: String
    var symbol_custom_emoji_id: String
    var light_theme_main_color: Int
    var light_theme_other_colors: List[Int]
    var dark_theme_main_color: Int
    var dark_theme_other_colors: List[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        model_custom_emoji_id: String,
        symbol_custom_emoji_id: String,
        light_theme_main_color: Int,
        light_theme_other_colors: List[Int],
        dark_theme_main_color: Int,
        dark_theme_other_colors: List[Int],
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.model_custom_emoji_id = model_custom_emoji_id.copy()
        self.symbol_custom_emoji_id = symbol_custom_emoji_id.copy()
        self.light_theme_main_color = light_theme_main_color
        self.light_theme_other_colors = List[Int](copy=light_theme_other_colors)
        self.dark_theme_main_color = dark_theme_main_color
        self.dark_theme_other_colors = List[Int](copy=dark_theme_other_colors)
        self.api_kwargs = _unique_gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.model_custom_emoji_id = existing.model_custom_emoji_id.copy()
        self.symbol_custom_emoji_id = existing.symbol_custom_emoji_id.copy()
        self.light_theme_main_color = existing.light_theme_main_color
        self.light_theme_other_colors = List[Int](copy=existing.light_theme_other_colors)
        self.dark_theme_main_color = existing.dark_theme_main_color
        self.dark_theme_other_colors = List[Int](copy=existing.dark_theme_other_colors)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.model_custom_emoji_id == other.model_custom_emoji_id and
            self.symbol_custom_emoji_id == other.symbol_custom_emoji_id and
            self.light_theme_main_color == other.light_theme_main_color and
            _unique_int_lists_equal(self.light_theme_other_colors, other.light_theme_other_colors) and
            self.dark_theme_main_color == other.dark_theme_main_color and
            _unique_int_lists_equal(self.dark_theme_other_colors, other.dark_theme_other_colors)
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.model_custom_emoji_id.as_bytes())
        hasher.update(self.symbol_custom_emoji_id.as_bytes())
        hasher.update(String(self.light_theme_main_color).as_bytes())
        for color in self.light_theme_other_colors:
            hasher.update(String(color).as_bytes())
        hasher.update(String(self.dark_theme_main_color).as_bytes())
        for color in self.dark_theme_other_colors:
            hasher.update(String(color).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "model_custom_emoji_id", self.model_custom_emoji_id)
        result.set_string(result.root, "symbol_custom_emoji_id", self.symbol_custom_emoji_id)
        result.set_number(result.root, "light_theme_main_color", String(self.light_theme_main_color))
        var light = result.add_array()
        for color in self.light_theme_other_colors:
            var item = result.add_number(String(color))
            result.append_child(light, item)
        result.object_set(result.root, "light_theme_other_colors", light)
        result.set_number(result.root, "dark_theme_main_color", String(self.dark_theme_main_color))
        var dark = result.add_array()
        for color in self.dark_theme_other_colors:
            var item = result.add_number(String(color))
            result.append_child(dark, item)
        result.object_set(result.root, "dark_theme_other_colors", dark)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UniqueGiftColors JSON value must be an object")
        var model = data.object_get(data.root, "model_custom_emoji_id")
        var symbol = data.object_get(data.root, "symbol_custom_emoji_id")
        var light_main = data.object_get(data.root, "light_theme_main_color")
        var light_other = data.object_get(data.root, "light_theme_other_colors")
        var dark_main = data.object_get(data.root, "dark_theme_main_color")
        var dark_other = data.object_get(data.root, "dark_theme_other_colors")
        if model == -1 or symbol == -1 or light_main == -1 or light_other == -1 or dark_main == -1 or dark_other == -1:
            raise Error("UniqueGiftColors JSON object is missing a required field")
        var known = List[String]()
        known.append("model_custom_emoji_id")
        known.append("symbol_custom_emoji_id")
        known.append("light_theme_main_color")
        known.append("light_theme_other_colors")
        known.append("dark_theme_main_color")
        known.append("dark_theme_other_colors")
        return Self(
            data.string_value(model),
            data.string_value(symbol),
            data.integer_value(light_main),
            _unique_gift_array(data, light_other),
            data.integer_value(dark_main),
            _unique_gift_array(data, dark_other),
            api_kwargs=Optional[JsonDocument](_unique_api_kwargs(data, known)),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^


struct UniqueGiftModel(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A named unique-gift model, its sticker, rarity, and optional craft tier."""

    var name: String
    var sticker: Sticker
    var rarity_per_mille: Int
    var rarity: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(out self, name: String, sticker: Sticker, rarity_per_mille: Int, rarity: Optional[String] = None, *, api_kwargs: Optional[JsonDocument] = None):
        self.name = name.copy()
        self.sticker = sticker.copy()
        self.rarity_per_mille = rarity_per_mille
        self.rarity = rarity.copy()
        self.api_kwargs = _unique_gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.sticker = existing.sticker.copy()
        self.rarity_per_mille = existing.rarity_per_mille
        self.rarity = existing.rarity.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name and self.sticker == other.sticker and self.rarity_per_mille == other.rarity_per_mille

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.name.as_bytes())
        hasher.update(self.sticker.file_unique_id.as_bytes())
        hasher.update(String(self.rarity_per_mille).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "name", self.name)
        var sticker = self.sticker.to_dict(recursive)
        var sticker_index = result.copy_subtree_from(sticker, sticker.root)
        result.object_set(result.root, "sticker", sticker_index)
        result.set_number(result.root, "rarity_per_mille", String(self.rarity_per_mille))
        if self.rarity is not None:
            result.set_string(result.root, "rarity", self.rarity.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UniqueGiftModel JSON value must be an object")
        var name = data.object_get(data.root, "name")
        var sticker_index = data.object_get(data.root, "sticker")
        var rarity_per_mille = data.object_get(data.root, "rarity_per_mille")
        if name == -1 or sticker_index == -1 or rarity_per_mille == -1:
            raise Error("UniqueGiftModel JSON object is missing a required field")
        var known = List[String]()
        known.append("name")
        known.append("sticker")
        known.append("rarity_per_mille")
        known.append("rarity")
        return Self(
            data.string_value(name),
            Sticker.de_json(_unique_gift_nested(data, sticker_index)),
            data.integer_value(rarity_per_mille),
            _unique_gift_optional_string(data, "rarity"),
            api_kwargs=Optional[JsonDocument](_unique_api_kwargs(data, known)),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^


struct UniqueGiftSymbol(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A named unique-gift symbol, sticker, and rarity."""

    var name: String
    var sticker: Sticker
    var rarity_per_mille: Int
    var api_kwargs: JsonDocument

    def __init__(out self, name: String, sticker: Sticker, rarity_per_mille: Int, *, api_kwargs: Optional[JsonDocument] = None):
        self.name = name.copy()
        self.sticker = sticker.copy()
        self.rarity_per_mille = rarity_per_mille
        self.api_kwargs = _unique_gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.sticker = existing.sticker.copy()
        self.rarity_per_mille = existing.rarity_per_mille
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name and self.sticker == other.sticker and self.rarity_per_mille == other.rarity_per_mille

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.name.as_bytes())
        hasher.update(self.sticker.file_unique_id.as_bytes())
        hasher.update(String(self.rarity_per_mille).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "name", self.name)
        var sticker = self.sticker.to_dict(recursive)
        var index = result.copy_subtree_from(sticker, sticker.root)
        result.object_set(result.root, "sticker", index)
        result.set_number(result.root, "rarity_per_mille", String(self.rarity_per_mille))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UniqueGiftSymbol JSON value must be an object")
        var name = data.object_get(data.root, "name")
        var sticker_index = data.object_get(data.root, "sticker")
        var rarity = data.object_get(data.root, "rarity_per_mille")
        if name == -1 or sticker_index == -1 or rarity == -1:
            raise Error("UniqueGiftSymbol JSON object is missing a required field")
        var known = List[String]()
        known.append("name")
        known.append("sticker")
        known.append("rarity_per_mille")
        return Self(
            data.string_value(name),
            Sticker.de_json(_unique_gift_nested(data, sticker_index)),
            data.integer_value(rarity),
            api_kwargs=Optional[JsonDocument](_unique_api_kwargs(data, known)),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^


struct UniqueGiftBackdrop(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A named unique-gift backdrop and its color palette."""

    var name: String
    var colors: UniqueGiftBackdropColors
    var rarity_per_mille: Int
    var api_kwargs: JsonDocument

    def __init__(out self, name: String, colors: UniqueGiftBackdropColors, rarity_per_mille: Int, *, api_kwargs: Optional[JsonDocument] = None):
        self.name = name.copy()
        self.colors = colors.copy()
        self.rarity_per_mille = rarity_per_mille
        self.api_kwargs = _unique_gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.colors = existing.colors.copy()
        self.rarity_per_mille = existing.rarity_per_mille
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name and self.colors == other.colors and self.rarity_per_mille == other.rarity_per_mille

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.name.as_bytes())
        hasher.update(String(self.colors.center_color).as_bytes())
        hasher.update(String(self.colors.edge_color).as_bytes())
        hasher.update(String(self.colors.symbol_color).as_bytes())
        hasher.update(String(self.colors.text_color).as_bytes())
        hasher.update(String(self.rarity_per_mille).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "name", self.name)
        var colors = self.colors.to_dict(recursive)
        var index = result.copy_subtree_from(colors, colors.root)
        result.object_set(result.root, "colors", index)
        result.set_number(result.root, "rarity_per_mille", String(self.rarity_per_mille))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UniqueGiftBackdrop JSON value must be an object")
        var name = data.object_get(data.root, "name")
        var colors_index = data.object_get(data.root, "colors")
        var rarity = data.object_get(data.root, "rarity_per_mille")
        if name == -1 or colors_index == -1 or rarity == -1:
            raise Error("UniqueGiftBackdrop JSON object is missing a required field")
        var known = List[String]()
        known.append("name")
        known.append("colors")
        known.append("rarity_per_mille")
        return Self(
            data.string_value(name),
            UniqueGiftBackdropColors.de_json(_unique_gift_nested(data, colors_index)),
            data.integer_value(rarity),
            api_kwargs=Optional[JsonDocument](_unique_api_kwargs(data, known)),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^


struct UniqueGift(Equatable, Hashable, Copyable, TelegramJsonObject):
    """An upgraded gift with its model, symbol, backdrop, and optional metadata."""

    var gift_id: String
    var base_name: String
    var name: String
    var number: Int
    var model: UniqueGiftModel
    var symbol: UniqueGiftSymbol
    var backdrop: UniqueGiftBackdrop
    var publisher_chat: Optional[Chat]
    var is_from_blockchain: Optional[Bool]
    var is_premium: Optional[Bool]
    var colors: Optional[UniqueGiftColors]
    var is_burned: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        gift_id: String,
        base_name: String,
        name: String,
        number: Int,
        model: UniqueGiftModel,
        symbol: UniqueGiftSymbol,
        backdrop: UniqueGiftBackdrop,
        publisher_chat: Optional[Chat] = None,
        is_from_blockchain: Optional[Bool] = None,
        is_premium: Optional[Bool] = None,
        colors: Optional[UniqueGiftColors] = None,
        is_burned: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.gift_id = gift_id.copy()
        self.base_name = base_name.copy()
        self.name = name.copy()
        self.number = number
        self.model = model.copy()
        self.symbol = symbol.copy()
        self.backdrop = backdrop.copy()
        self.publisher_chat = publisher_chat.copy()
        self.is_from_blockchain = is_from_blockchain.copy()
        self.is_premium = is_premium.copy()
        self.colors = colors.copy()
        self.is_burned = is_burned.copy()
        self.api_kwargs = _unique_gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.gift_id = existing.gift_id.copy()
        self.base_name = existing.base_name.copy()
        self.name = existing.name.copy()
        self.number = existing.number
        self.model = existing.model.copy()
        self.symbol = existing.symbol.copy()
        self.backdrop = existing.backdrop.copy()
        self.publisher_chat = existing.publisher_chat.copy()
        self.is_from_blockchain = existing.is_from_blockchain.copy()
        self.is_premium = existing.is_premium.copy()
        self.colors = existing.colors.copy()
        self.is_burned = existing.is_burned.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.base_name == other.base_name and self.name == other.name and
            self.number == other.number and self.model == other.model and
            self.symbol == other.symbol and self.backdrop == other.backdrop
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.base_name.as_bytes())
        hasher.update(self.name.as_bytes())
        hasher.update(String(self.number).as_bytes())
        hasher.update(String(hash(self.model)).as_bytes())
        hasher.update(String(hash(self.symbol)).as_bytes())
        hasher.update(String(hash(self.backdrop)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var backdrop = self.backdrop.to_dict(recursive)
        var backdrop_index = result.copy_subtree_from(backdrop, backdrop.root)
        result.object_set(result.root, "backdrop", backdrop_index)
        result.set_string(result.root, "base_name", self.base_name)
        if self.colors is not None:
            var colors = self.colors.value().to_dict(recursive)
            var colors_index = result.copy_subtree_from(colors, colors.root)
            result.object_set(result.root, "colors", colors_index)
        result.set_string(result.root, "gift_id", self.gift_id)
        if self.is_burned is not None:
            result.set_boolean(result.root, "is_burned", self.is_burned.value())
        if self.is_from_blockchain is not None:
            result.set_boolean(result.root, "is_from_blockchain", self.is_from_blockchain.value())
        if self.is_premium is not None:
            result.set_boolean(result.root, "is_premium", self.is_premium.value())
        var model = self.model.to_dict(recursive)
        var model_index = result.copy_subtree_from(model, model.root)
        result.object_set(result.root, "model", model_index)
        result.set_string(result.root, "name", self.name)
        result.set_number(result.root, "number", String(self.number))
        if self.publisher_chat is not None:
            var chat = self.publisher_chat.value().to_dict(recursive)
            var chat_index = result.copy_subtree_from(chat, chat.root)
            result.object_set(result.root, "publisher_chat", chat_index)
        var symbol = self.symbol.to_dict(recursive)
        var symbol_index = result.copy_subtree_from(symbol, symbol.root)
        result.object_set(result.root, "symbol", symbol_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UniqueGift JSON value must be an object")
        var gift_id = data.object_get(data.root, "gift_id")
        var base_name = data.object_get(data.root, "base_name")
        var name = data.object_get(data.root, "name")
        var number = data.object_get(data.root, "number")
        var model = data.object_get(data.root, "model")
        var symbol = data.object_get(data.root, "symbol")
        var backdrop = data.object_get(data.root, "backdrop")
        if gift_id == -1 or base_name == -1 or name == -1 or number == -1 or model == -1 or symbol == -1 or backdrop == -1:
            raise Error("UniqueGift JSON object is missing a required field")
        var publisher_chat: Optional[Chat] = None
        var chat_index = data.object_get(data.root, "publisher_chat")
        if chat_index != -1 and not data.is_null(chat_index):
            publisher_chat = Optional[Chat](Chat.de_json(_unique_gift_nested(data, chat_index)))
        var colors: Optional[UniqueGiftColors] = None
        var colors_index = data.object_get(data.root, "colors")
        if colors_index != -1 and not data.is_null(colors_index):
            colors = Optional[UniqueGiftColors](UniqueGiftColors.de_json(_unique_gift_nested(data, colors_index)))
        var known = List[String]()
        known.append("gift_id")
        known.append("base_name")
        known.append("name")
        known.append("number")
        known.append("model")
        known.append("symbol")
        known.append("backdrop")
        known.append("publisher_chat")
        known.append("is_from_blockchain")
        known.append("is_premium")
        known.append("colors")
        known.append("is_burned")
        return Self(
            data.string_value(gift_id),
            data.string_value(base_name),
            data.string_value(name),
            data.integer_value(number),
            UniqueGiftModel.de_json(_unique_gift_nested(data, model)),
            UniqueGiftSymbol.de_json(_unique_gift_nested(data, symbol)),
            UniqueGiftBackdrop.de_json(_unique_gift_nested(data, backdrop)),
            publisher_chat,
            _unique_gift_optional_bool(data, "is_from_blockchain"),
            _unique_gift_optional_bool(data, "is_premium"),
            colors,
            _unique_gift_optional_bool(data, "is_burned"),
            api_kwargs=Optional[JsonDocument](_unique_api_kwargs(data, known)),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^


struct UniqueGiftInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Service-message metadata for a unique gift and its transfer origin."""

    comptime UPGRADE = "upgrade"
    comptime TRANSFER = "transfer"
    comptime RESALE = "resale"
    comptime GIFTED_UPGRADE = "gifted_upgrade"
    comptime OFFER = "offer"

    var gift: UniqueGift
    var origin: String
    var owned_gift_id: Optional[String]
    var transfer_star_count: Optional[Int]
    var next_transfer_date: Optional[TimestampDateTime]
    var last_resale_currency: Optional[String]
    var last_resale_amount: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        gift: UniqueGift,
        origin: String,
        owned_gift_id: Optional[String] = None,
        transfer_star_count: Optional[Int] = None,
        next_transfer_date: Optional[TimestampDateTime] = None,
        last_resale_currency: Optional[String] = None,
        last_resale_amount: Optional[Int] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.gift = gift.copy()
        self.origin = origin.copy()
        self.owned_gift_id = owned_gift_id.copy()
        self.transfer_star_count = transfer_star_count.copy()
        self.next_transfer_date = next_transfer_date.copy()
        self.last_resale_currency = last_resale_currency.copy()
        self.last_resale_amount = last_resale_amount.copy()
        self.api_kwargs = _unique_gift_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.gift = existing.gift.copy()
        self.origin = existing.origin.copy()
        self.owned_gift_id = existing.owned_gift_id.copy()
        self.transfer_star_count = existing.transfer_star_count.copy()
        self.next_transfer_date = existing.next_transfer_date.copy()
        self.last_resale_currency = existing.last_resale_currency.copy()
        self.last_resale_amount = existing.last_resale_amount.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.gift == other.gift and self.origin == other.origin

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(hash(self.gift)).as_bytes())
        hasher.update(self.origin.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var gift = self.gift.to_dict(recursive)
        var gift_index = result.copy_subtree_from(gift, gift.root)
        result.object_set(result.root, "gift", gift_index)
        if self.last_resale_amount is not None:
            result.set_number(result.root, "last_resale_amount", String(self.last_resale_amount.value()))
        if self.last_resale_currency is not None:
            result.set_string(result.root, "last_resale_currency", self.last_resale_currency.value())
        if self.next_transfer_date is not None:
            result.set_number(
                result.root,
                "next_transfer_date",
                String(to_timestamp(self.next_transfer_date.value())),
            )
        result.set_string(result.root, "origin", self.origin)
        if self.owned_gift_id is not None:
            result.set_string(result.root, "owned_gift_id", self.owned_gift_id.value())
        if self.transfer_star_count is not None:
            result.set_number(result.root, "transfer_star_count", String(self.transfer_star_count.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UniqueGiftInfo JSON value must be an object")
        var gift_index = data.object_get(data.root, "gift")
        var origin_index = data.object_get(data.root, "origin")
        if gift_index == -1 or origin_index == -1:
            raise Error("UniqueGiftInfo JSON object is missing a required field")
        var next_transfer_date: Optional[TimestampDateTime] = None
        var date_index = data.object_get(data.root, "next_transfer_date")
        if date_index != -1 and not data.is_null(date_index):
            next_transfer_date = from_timestamp(Optional[Int](data.integer_value(date_index)))
        var known = List[String]()
        known.append("gift")
        known.append("origin")
        known.append("owned_gift_id")
        known.append("transfer_star_count")
        known.append("next_transfer_date")
        known.append("last_resale_currency")
        known.append("last_resale_amount")
        return Self(
            UniqueGift.de_json(_unique_gift_nested(data, gift_index)),
            data.string_value(origin_index),
            _unique_gift_optional_string(data, "owned_gift_id"),
            _unique_gift_optional_int(data, "transfer_star_count"),
            next_transfer_date,
            _unique_gift_optional_string(data, "last_resale_currency"),
            _unique_gift_optional_int(data, "last_resale_amount"),
            api_kwargs=Optional[JsonDocument](_unique_api_kwargs(data, known)),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for item in documents:
            result.append(Self.de_json(item))
        return result^

struct UniqueGiftBackdropColors(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream UniqueGiftBackdropColors."""

    var center_color: Int
    var edge_color: Int
    var symbol_color: Int
    var text_color: Int
    var api_kwargs: JsonDocument

    def __init__(out self, center_color: Int, edge_color: Int, symbol_color: Int, text_color: Int):
        self.center_color = center_color
        self.edge_color = edge_color
        self.symbol_color = symbol_color
        self.text_color = text_color
        self.api_kwargs = empty_json_object()

    def __init__(out self, center_color: Int, edge_color: Int, symbol_color: Int, text_color: Int, api_kwargs: JsonDocument):
        self.center_color = center_color
        self.edge_color = edge_color
        self.symbol_color = symbol_color
        self.text_color = text_color
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.center_color = existing.center_color
        self.edge_color = existing.edge_color
        self.symbol_color = existing.symbol_color
        self.text_color = existing.text_color
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.center_color == other.center_color and self.edge_color == other.edge_color and self.symbol_color == other.symbol_color and self.text_color == other.text_color

    def __hash__[H: Hasher](self, mut hasher: H):
        var center_color_hash_text = String(self.center_color)
        hasher.update(center_color_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var edge_color_hash_text = String(self.edge_color)
        hasher.update(edge_color_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var symbol_color_hash_text = String(self.symbol_color)
        hasher.update(symbol_color_hash_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        var text_color_hash_text = String(self.text_color)
        hasher.update(text_color_hash_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "center_color", String(self.center_color))
        result.set_number(result.root, "edge_color", String(self.edge_color))
        result.set_number(result.root, "symbol_color", String(self.symbol_color))
        result.set_number(result.root, "text_color", String(self.text_color))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> UniqueGiftBackdropColors:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("UniqueGiftBackdropColors JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UniqueGiftBackdropColors JSON value is not an object")
        var parsed_center_color_index = data.object_get(data.root, "center_color")
        if parsed_center_color_index == -1:
            raise Error("UniqueGiftBackdropColors JSON object is missing center_color")
        var parsed_center_color = data.integer_value(parsed_center_color_index)
        var parsed_edge_color_index = data.object_get(data.root, "edge_color")
        if parsed_edge_color_index == -1:
            raise Error("UniqueGiftBackdropColors JSON object is missing edge_color")
        var parsed_edge_color = data.integer_value(parsed_edge_color_index)
        var parsed_symbol_color_index = data.object_get(data.root, "symbol_color")
        if parsed_symbol_color_index == -1:
            raise Error("UniqueGiftBackdropColors JSON object is missing symbol_color")
        var parsed_symbol_color = data.integer_value(parsed_symbol_color_index)
        var parsed_text_color_index = data.object_get(data.root, "text_color")
        if parsed_text_color_index == -1:
            raise Error("UniqueGiftBackdropColors JSON object is missing text_color")
        var parsed_text_color = data.integer_value(parsed_text_color_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "center_color" and key != "edge_color" and key != "symbol_color" and key != "text_color":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return UniqueGiftBackdropColors(parsed_center_color, parsed_edge_color, parsed_symbol_color, parsed_text_color, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[UniqueGiftBackdropColors]:
        var items = data.array_documents(array_index)
        var result = List[UniqueGiftBackdropColors]()
        for index in range(len(items)):
            result.append(UniqueGiftBackdropColors.de_json(items[index].copy()))
        return result^
