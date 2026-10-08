#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 ChatPhoto.
# LGPL-3.0-or-later; see LICENSE.

"""The small and large photo variants of a chat profile image."""

from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct ChatPhoto(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A chat profile photo, identified by both size variants' stable IDs."""

    comptime SIZE_SMALL = constants.ChatPhotoSize.SMALL.value
    comptime SIZE_BIG = constants.ChatPhotoSize.BIG.value

    var small_file_id: String
    var small_file_unique_id: String
    var big_file_id: String
    var big_file_unique_id: String
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        small_file_id: String,
        small_file_unique_id: String,
        big_file_id: String,
        big_file_unique_id: String,
    ):
        self.small_file_id = small_file_id.copy()
        self.small_file_unique_id = small_file_unique_id.copy()
        self.big_file_id = big_file_id.copy()
        self.big_file_unique_id = big_file_unique_id.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        small_file_id: String,
        small_file_unique_id: String,
        big_file_id: String,
        big_file_unique_id: String,
        *,
        api_kwargs: JsonDocument,
    ):
        self.small_file_id = small_file_id.copy()
        self.small_file_unique_id = small_file_unique_id.copy()
        self.big_file_id = big_file_id.copy()
        self.big_file_unique_id = big_file_unique_id.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.small_file_id = existing.small_file_id.copy()
        self.small_file_unique_id = existing.small_file_unique_id.copy()
        self.big_file_id = existing.big_file_id.copy()
        self.big_file_unique_id = existing.big_file_unique_id.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.small_file_unique_id == other.small_file_unique_id
            and self.big_file_unique_id == other.big_file_unique_id
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.small_file_unique_id.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.big_file_unique_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "small_file_id", self.small_file_id)
        result.set_string(result.root, "small_file_unique_id", self.small_file_unique_id)
        result.set_string(result.root, "big_file_id", self.big_file_id)
        result.set_string(result.root, "big_file_unique_id", self.big_file_unique_id)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ChatPhoto JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatPhoto JSON value is not an object")
        var small_file_id_index = data.object_get(data.root, "small_file_id")
        var small_file_unique_id_index = data.object_get(data.root, "small_file_unique_id")
        var big_file_id_index = data.object_get(data.root, "big_file_id")
        var big_file_unique_id_index = data.object_get(data.root, "big_file_unique_id")
        if (
            small_file_id_index == -1
            or small_file_unique_id_index == -1
            or big_file_id_index == -1
            or big_file_unique_id_index == -1
        ):
            raise Error("ChatPhoto JSON object is missing a required field")
        var small_file_id = data.string_value(small_file_id_index)
        var small_file_unique_id = data.string_value(small_file_unique_id_index)
        var big_file_id = data.string_value(big_file_id_index)
        var big_file_unique_id = data.string_value(big_file_unique_id_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "small_file_id"
                and key != "small_file_unique_id"
                and key != "big_file_id"
                and key != "big_file_unique_id"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatPhoto(
            small_file_id,
            small_file_unique_id,
            big_file_id,
            big_file_unique_id,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(ChatPhoto.de_json(items[index].copy()))
        return result^
