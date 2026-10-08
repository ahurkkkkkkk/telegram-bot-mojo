#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ForceReply.
# LGPL-3.0-or-later; see LICENSE.

"""A reply keyboard request and its Bot API JSON conversion."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ForceReply(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Shows a reply interface; equality follows upstream's ``selective`` field."""

    comptime MIN_INPUT_FIELD_PLACEHOLDER = constants.ReplyLimit.MIN_INPUT_FIELD_PLACEHOLDER.value
    comptime MAX_INPUT_FIELD_PLACEHOLDER = constants.ReplyLimit.MAX_INPUT_FIELD_PLACEHOLDER.value

    var force_reply: Bool
    var selective: Optional[Bool]
    var input_field_placeholder: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        selective: Optional[Bool] = None,
        input_field_placeholder: Optional[String] = None,
    ):
        self.force_reply = True
        self.selective = selective
        self.input_field_placeholder = input_field_placeholder
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        selective: Optional[Bool] = None,
        input_field_placeholder: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.force_reply = True
        self.selective = selective
        self.input_field_placeholder = input_field_placeholder
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.force_reply = existing.force_reply
        self.selective = existing.selective
        self.input_field_placeholder = existing.input_field_placeholder
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.selective is None or other.selective is None:
            return self.selective is None and other.selective is None
        return self.selective.value() == other.selective.value()

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.selective is None:
            hasher.update(String("none").as_bytes())
        elif self.selective.value():
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "force_reply", self.force_reply)
        if self.input_field_placeholder is not None:
            result.set_string(
                result.root, "input_field_placeholder", self.input_field_placeholder.value()
            )
        if self.selective is not None:
            result.set_boolean(result.root, "selective", self.selective.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ForceReply JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ForceReply JSON value is not an object")
        var selective: Optional[Bool] = None
        var selective_index = data.object_get(data.root, "selective")
        if selective_index != -1 and not data.is_null(selective_index):
            selective = Optional[Bool](data.boolean_value(selective_index))
        var input_field_placeholder: Optional[String] = None
        var placeholder_index = data.object_get(data.root, "input_field_placeholder")
        if placeholder_index != -1 and not data.is_null(placeholder_index):
            input_field_placeholder = Optional[String](data.string_value(placeholder_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "force_reply" and key != "selective" and key != "input_field_placeholder":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ForceReply(selective, input_field_placeholder, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ForceReply.de_json(items[index].copy()))
        return result^
