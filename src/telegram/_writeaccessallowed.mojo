#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _writeaccessallowed.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct WriteAccessAllowed(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream WriteAccessAllowed."""

    var web_app_name: Optional[String]
    var from_request: Optional[Bool]
    var from_attachment_menu: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, web_app_name: Optional[String] = None, from_request: Optional[Bool] = None, from_attachment_menu: Optional[Bool] = None):
        self.web_app_name = web_app_name
        self.from_request = from_request
        self.from_attachment_menu = from_attachment_menu
        self.api_kwargs = empty_json_object()

    def __init__(out self, web_app_name: Optional[String] = None, from_request: Optional[Bool] = None, from_attachment_menu: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.web_app_name = web_app_name
        self.from_request = from_request
        self.from_attachment_menu = from_attachment_menu
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.web_app_name = existing.web_app_name
        self.from_request = existing.from_request
        self.from_attachment_menu = existing.from_attachment_menu
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.web_app_name == other.web_app_name

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.web_app_name is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            hasher.update(self.web_app_name.value().as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.from_attachment_menu is not None:
            result.set_boolean(result.root, "from_attachment_menu", self.from_attachment_menu.value())
        if self.from_request is not None:
            result.set_boolean(result.root, "from_request", self.from_request.value())
        if self.web_app_name is not None:
            result.set_string(result.root, "web_app_name", self.web_app_name.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> WriteAccessAllowed:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("WriteAccessAllowed JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("WriteAccessAllowed JSON value is not an object")
        var parsed_web_app_name_index = data.object_get(data.root, "web_app_name")
        var parsed_web_app_name: Optional[String] = None
        if parsed_web_app_name_index != -1 and not data.is_null(parsed_web_app_name_index):
            parsed_web_app_name = Optional[String](data.string_value(parsed_web_app_name_index))
        var parsed_from_request_index = data.object_get(data.root, "from_request")
        var parsed_from_request: Optional[Bool] = None
        if parsed_from_request_index != -1 and not data.is_null(parsed_from_request_index):
            parsed_from_request = Optional[Bool](data.boolean_value(parsed_from_request_index))
        var parsed_from_attachment_menu_index = data.object_get(data.root, "from_attachment_menu")
        var parsed_from_attachment_menu: Optional[Bool] = None
        if parsed_from_attachment_menu_index != -1 and not data.is_null(parsed_from_attachment_menu_index):
            parsed_from_attachment_menu = Optional[Bool](data.boolean_value(parsed_from_attachment_menu_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "web_app_name" and key != "from_request" and key != "from_attachment_menu":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return WriteAccessAllowed(parsed_web_app_name, parsed_from_request, parsed_from_attachment_menu, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[WriteAccessAllowed]:
        var items = data.array_documents(array_index)
        var result = List[WriteAccessAllowed]()
        for index in range(len(items)):
            result.append(WriteAccessAllowed.de_json(items[index].copy()))
        return result^
