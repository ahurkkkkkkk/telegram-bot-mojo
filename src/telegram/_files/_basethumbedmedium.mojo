#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 _BaseThumbedMedium.
# LGPL-3.0-or-later; see LICENSE.

"""Common file fields and thumbnail conversion for Telegram media values."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.photosize import PhotoSize
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct _BaseThumbedMedium(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Shared file fields plus the current and legacy thumbnail JSON fields."""

    var file_id: String
    var file_unique_id: String
    var file_size: Optional[Int]
    var thumbnail: Optional[PhotoSize]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        file_size: Optional[Int] = None,
        thumbnail: Optional[PhotoSize] = None,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.file_size = file_size
        self.thumbnail = thumbnail.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        file_size: Optional[Int] = None,
        thumbnail: Optional[PhotoSize] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.file_size = file_size
        self.thumbnail = thumbnail.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.file_id = existing.file_id.copy()
        self.file_unique_id = existing.file_unique_id.copy()
        self.file_size = existing.file_size
        self.thumbnail = existing.thumbnail.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.file_unique_id == other.file_unique_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.file_unique_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "file_id", self.file_id)
        result.set_string(result.root, "file_unique_id", self.file_unique_id)
        if self.file_size is not None:
            result.set_number(result.root, "file_size", String(self.file_size.value()))
        if self.thumbnail is not None:
            var thumbnail_data = self.thumbnail.value().to_dict(recursive=recursive)
            var thumbnail_index = result.copy_subtree_from(thumbnail_data, thumbnail_data.root)
            result.object_set(result.root, "thumbnail", thumbnail_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("_BaseThumbedMedium JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("_BaseThumbedMedium JSON value is not an object")
        var file_id_index = data.object_get(data.root, "file_id")
        var file_unique_id_index = data.object_get(data.root, "file_unique_id")
        if file_id_index == -1 or file_unique_id_index == -1:
            raise Error("_BaseThumbedMedium JSON object is missing a required field")
        var file_id = data.string_value(file_id_index)
        var file_unique_id = data.string_value(file_unique_id_index)
        var file_size: Optional[Int] = None
        var file_size_index = data.object_get(data.root, "file_size")
        if file_size_index != -1 and not data.is_null(file_size_index):
            file_size = Optional[Int](data.integer_value(file_size_index))
        var thumbnail: Optional[PhotoSize] = None
        var thumbnail_index = data.object_get(data.root, "thumbnail")
        if thumbnail_index != -1 and not data.is_null(thumbnail_index):
            var thumbnail_data = JsonDocument()
            thumbnail_data.root = thumbnail_data.copy_subtree_from(data, thumbnail_index)
            thumbnail = Optional[PhotoSize](PhotoSize.de_json(thumbnail_data))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "file_id"
                and key != "file_unique_id"
                and key != "file_size"
                and key != "thumbnail"
            ):
                # This also retains Telegram's deprecated "thumb" response key exactly as
                # upstream moves it into api_kwargs for backwards-compatible serialization.
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return _BaseThumbedMedium(
            file_id,
            file_unique_id,
            file_size,
            thumbnail,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
