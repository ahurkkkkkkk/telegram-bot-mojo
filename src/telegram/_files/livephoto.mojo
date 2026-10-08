#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 LivePhoto.
# LGPL-3.0-or-later; see LICENSE.

"""A live photo video with optional still-image sizes."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.photosize import PhotoSize
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct LivePhoto(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Telegram live photo; equality uses its stable ``file_unique_id``."""

    var file_id: String
    var file_unique_id: String
    var width: Int
    var height: Int
    var duration: TimeDelta
    var photo: List[PhotoSize]
    var mime_type: Optional[String]
    var file_size: Optional[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        width: Int,
        height: Int,
        duration: TimeDelta,
        photo: Optional[List[PhotoSize]] = None,
        mime_type: Optional[String] = None,
        file_size: Optional[Int] = None,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.width = width
        self.height = height
        self.duration = duration.copy()
        self.photo = List[PhotoSize]()
        if photo is not None:
            self.photo = List[PhotoSize](copy=photo.value())
        self.mime_type = mime_type
        self.file_size = file_size
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        width: Int,
        height: Int,
        duration: TimeDelta,
        photo: Optional[List[PhotoSize]] = None,
        mime_type: Optional[String] = None,
        file_size: Optional[Int] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.width = width
        self.height = height
        self.duration = duration.copy()
        self.photo = List[PhotoSize]()
        if photo is not None:
            self.photo = List[PhotoSize](copy=photo.value())
        self.mime_type = mime_type
        self.file_size = file_size
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.file_id = existing.file_id.copy()
        self.file_unique_id = existing.file_unique_id.copy()
        self.width = existing.width
        self.height = existing.height
        self.duration = existing.duration.copy()
        self.photo = List[PhotoSize](copy=existing.photo)
        self.mime_type = existing.mime_type
        self.file_size = existing.file_size
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.file_unique_id == other.file_unique_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.file_unique_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "file_id", self.file_id)
        result.set_string(result.root, "file_unique_id", self.file_unique_id)
        result.set_number(result.root, "width", String(self.width))
        result.set_number(result.root, "height", String(self.height))
        result.set_number(result.root, "duration", self.duration.seconds_json_number())
        if len(self.photo) > 0:
            var photo_array = result.add_array()
            for size in self.photo:
                var item = size.to_dict(recursive=recursive)
                var copied = result.copy_subtree_from(item, item.root)
                result.append_child(photo_array, copied)
            result.object_set(result.root, "photo", photo_array)
        if self.mime_type is not None:
            result.set_string(result.root, "mime_type", self.mime_type.value())
        if self.file_size is not None:
            result.set_number(result.root, "file_size", String(self.file_size.value()))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("LivePhoto JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("LivePhoto JSON value is not an object")
        var file_id_index = data.object_get(data.root, "file_id")
        var file_unique_id_index = data.object_get(data.root, "file_unique_id")
        var width_index = data.object_get(data.root, "width")
        var height_index = data.object_get(data.root, "height")
        var duration_index = data.object_get(data.root, "duration")
        if (
            file_id_index == -1
            or file_unique_id_index == -1
            or width_index == -1
            or height_index == -1
            or duration_index == -1
        ):
            raise Error("LivePhoto JSON object is missing a required field")
        var file_id = data.string_value(file_id_index)
        var file_unique_id = data.string_value(file_unique_id_index)
        var width = data.integer_value(width_index)
        var height = data.integer_value(height_index)
        var duration = to_timedelta(atof(data.number_text(duration_index)))
        var photo = List[PhotoSize]()
        var photo_index = data.object_get(data.root, "photo")
        if photo_index != -1 and not data.is_null(photo_index):
            var photo_documents = data.array_documents(photo_index)
            for index in range(len(photo_documents)):
                photo.append(PhotoSize.de_json(photo_documents[index].copy()))
        var mime_type: Optional[String] = None
        var mime_type_index = data.object_get(data.root, "mime_type")
        if mime_type_index != -1 and not data.is_null(mime_type_index):
            mime_type = Optional[String](data.string_value(mime_type_index))
        var file_size: Optional[Int] = None
        var file_size_index = data.object_get(data.root, "file_size")
        if file_size_index != -1 and not data.is_null(file_size_index):
            file_size = Optional[Int](data.integer_value(file_size_index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "file_id"
                and key != "file_unique_id"
                and key != "width"
                and key != "height"
                and key != "duration"
                and key != "photo"
                and key != "mime_type"
                and key != "file_size"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        var photo_value = Optional[List[PhotoSize]](photo^)
        return LivePhoto(
            file_id,
            file_unique_id,
            width,
            height,
            duration,
            photo_value,
            mime_type,
            file_size,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(LivePhoto.de_json(items[index].copy()))
        return result^
