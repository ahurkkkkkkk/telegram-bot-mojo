#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _menubutton.py.
# LGPL-3.0-or-later; see LICENSE.

"""Menu button models and JSON conversion for the Telegram Bot API."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._webappinfo import WebAppInfo


struct MenuButton(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Base menu button representation.

    ``de_json`` preserves the Telegram variant tag and all fields in one native
    value. Mojo does not provide Python's runtime subclass dispatch, so callers
    that need a statically typed variant can use the three variant structs.
    """

    comptime COMMANDS = "commands"
    comptime WEB_APP = "web_app"
    comptime DEFAULT = "default"

    var type: String
    var text: Optional[String]
    var web_app: Optional[WebAppInfo]
    var api_kwargs: JsonDocument

    def __init__(out self, type: String):
        self.type = type.copy()
        self.text = None
        self.web_app = None
        self.api_kwargs = empty_json_object()

    def __init__(out self, type: String, *, api_kwargs: JsonDocument):
        self.type = type.copy()
        self.text = None
        self.web_app = None
        self.api_kwargs = api_kwargs.copy()

    def __init__(out self, type: String, text: String, web_app: WebAppInfo, *, api_kwargs: JsonDocument):
        self.type = type.copy()
        self.text = Optional[String](text.copy())
        self.web_app = Optional[WebAppInfo](web_app.copy())
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.text = existing.text
        if existing.text is not None:
            self.text = Optional[String](existing.text.value().copy())
        self.web_app = existing.web_app
        if existing.web_app is not None:
            self.web_app = Optional[WebAppInfo](existing.web_app.value().copy())
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        # Matches MenuButton's base-class identity contract (type only).
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("MenuButton\0").as_bytes())
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        if self.text is not None:
            result.set_string(result.root, "text", self.text.value())
        if self.web_app is not None:
            var nested = self.web_app.value().to_dict(recursive=recursive)
            var nested_node = result.copy_subtree_from(nested, nested.root)
            result.object_set(result.root, "web_app", nested_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MenuButton JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1:
            raise Error("MenuButton JSON object is missing type")
        var type = data.string_value(type_index)
        var text: Optional[String] = None
        var text_index = data.object_get(data.root, "text")
        if text_index != -1 and not data.is_null(text_index):
            text = Optional[String](data.string_value(text_index))
        var web_app: Optional[WebAppInfo] = None
        var web_app_index = data.object_get(data.root, "web_app")
        if web_app_index != -1 and not data.is_null(web_app_index):
            var nested = JsonDocument()
            nested.root = nested.copy_subtree_from(data, web_app_index)
            web_app = Optional[WebAppInfo](WebAppInfo.de_json(nested))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type" and key != "text" and key != "web_app":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        if type == Self.WEB_APP:
            if text is None or web_app is None:
                raise Error("MenuButtonWebApp JSON requires text and web_app")
            return MenuButton(type, text.value(), web_app.value(), api_kwargs=api_kwargs)
        return MenuButton(type, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MenuButton.de_json(items[index].copy()))
        return result^


struct MenuButtonCommands(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents a menu button that opens the bot's command list."""

    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self):
        self.type = String("commands")
        self.api_kwargs = empty_json_object()

    def __init__(out self, *, api_kwargs: JsonDocument):
        self.type = String("commands")
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("MenuButtonCommands\0commands").as_bytes())
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MenuButtonCommands JSON value must be an object")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return MenuButtonCommands(api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MenuButtonCommands.de_json(items[index].copy()))
        return result^


struct MenuButtonWebApp(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Represents a menu button that launches a Telegram Web App."""

    var type: String
    var text: String
    var web_app: WebAppInfo
    var api_kwargs: JsonDocument

    def __init__(out self, text: String, web_app: WebAppInfo):
        self.type = String("web_app")
        self.text = text.copy()
        self.web_app = web_app.copy()
        self.api_kwargs = empty_json_object()

    def __init__(out self, text: String, web_app: WebAppInfo, *, api_kwargs: JsonDocument):
        self.type = String("web_app")
        self.text = text.copy()
        self.web_app = web_app.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.text = existing.text.copy()
        self.web_app = existing.web_app.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type and self.text == other.text and self.web_app == other.web_app

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.text.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.web_app.url.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "text", self.text)
        var nested = self.web_app.to_dict(recursive=recursive)
        var nested_node = result.copy_subtree_from(nested, nested.root)
        result.object_set(result.root, "web_app", nested_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MenuButtonWebApp JSON value must be an object")
        var text_index = data.object_get(data.root, "text")
        var web_app_index = data.object_get(data.root, "web_app")
        if text_index == -1 or web_app_index == -1 or data.is_null(web_app_index):
            raise Error("MenuButtonWebApp JSON requires text and web_app")
        var nested = JsonDocument()
        nested.root = nested.copy_subtree_from(data, web_app_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type" and key != "text" and key != "web_app":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return MenuButtonWebApp(
            data.string_value(text_index), WebAppInfo.de_json(nested), api_kwargs=api_kwargs
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MenuButtonWebApp.de_json(items[index].copy()))
        return result^


struct MenuButtonDefault(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Describes that no chat-specific menu button was set."""

    var type: String
    var api_kwargs: JsonDocument

    def __init__(out self):
        self.type = String("default")
        self.api_kwargs = empty_json_object()

    def __init__(out self, *, api_kwargs: JsonDocument):
        self.type = String("default")
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.type == other.type

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("MenuButtonDefault\0default").as_bytes())
        hasher.update(self.type.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MenuButtonDefault JSON value must be an object")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "type":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return MenuButtonDefault(api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MenuButtonDefault.de_json(items[index].copy()))
        return result^
