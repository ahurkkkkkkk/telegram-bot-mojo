#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 Video.
# LGPL-3.0-or-later; see LICENSE.

"""A Telegram video with optional cover images and encoded qualities."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.photosize import PhotoSize
from telegram._files.videoquality import VideoQuality
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct Video(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A video; equality uses its stable ``file_unique_id``."""

    var file_id: String
    var file_unique_id: String
    var width: Int
    var height: Int
    var duration: TimeDelta
    var mime_type: Optional[String]
    var file_size: Optional[Int]
    var file_name: Optional[String]
    var thumbnail: Optional[PhotoSize]
    var cover: List[PhotoSize]
    var start_timestamp: Optional[TimeDelta]
    var qualities: List[VideoQuality]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        width: Int,
        height: Int,
        duration: TimeDelta,
        mime_type: Optional[String] = None,
        file_size: Optional[Int] = None,
        file_name: Optional[String] = None,
        thumbnail: Optional[PhotoSize] = None,
        cover: Optional[List[PhotoSize]] = None,
        start_timestamp: Optional[TimeDelta] = None,
        qualities: Optional[List[VideoQuality]] = None,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.width = width
        self.height = height
        self.duration = duration.copy()
        self.mime_type = mime_type
        self.file_size = file_size
        self.file_name = file_name
        self.thumbnail = thumbnail.copy()
        self.cover = List[PhotoSize]()
        if cover is not None:
            self.cover = List[PhotoSize](copy=cover.value())
        self.start_timestamp = start_timestamp.copy()
        self.qualities = List[VideoQuality]()
        if qualities is not None:
            self.qualities = List[VideoQuality](copy=qualities.value())
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        width: Int,
        height: Int,
        duration: TimeDelta,
        mime_type: Optional[String] = None,
        file_size: Optional[Int] = None,
        file_name: Optional[String] = None,
        thumbnail: Optional[PhotoSize] = None,
        cover: Optional[List[PhotoSize]] = None,
        start_timestamp: Optional[TimeDelta] = None,
        qualities: Optional[List[VideoQuality]] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.width = width
        self.height = height
        self.duration = duration.copy()
        self.mime_type = mime_type
        self.file_size = file_size
        self.file_name = file_name
        self.thumbnail = thumbnail.copy()
        self.cover = List[PhotoSize]()
        if cover is not None:
            self.cover = List[PhotoSize](copy=cover.value())
        self.start_timestamp = start_timestamp.copy()
        self.qualities = List[VideoQuality]()
        if qualities is not None:
            self.qualities = List[VideoQuality](copy=qualities.value())
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.file_id = existing.file_id.copy()
        self.file_unique_id = existing.file_unique_id.copy()
        self.width = existing.width
        self.height = existing.height
        self.duration = existing.duration.copy()
        self.mime_type = existing.mime_type
        self.file_size = existing.file_size
        self.file_name = existing.file_name
        self.thumbnail = existing.thumbnail.copy()
        self.cover = List[PhotoSize](copy=existing.cover)
        self.start_timestamp = existing.start_timestamp.copy()
        self.qualities = List[VideoQuality](copy=existing.qualities)
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
        if self.mime_type is not None:
            result.set_string(result.root, "mime_type", self.mime_type.value())
        if self.file_size is not None:
            result.set_number(result.root, "file_size", String(self.file_size.value()))
        if self.file_name is not None:
            result.set_string(result.root, "file_name", self.file_name.value())
        if self.thumbnail is not None:
            var thumbnail = self.thumbnail.value().to_dict(recursive=recursive)
            var thumbnail_node = result.copy_subtree_from(thumbnail, thumbnail.root)
            result.object_set(result.root, "thumbnail", thumbnail_node)
        if len(self.cover) > 0:
            var cover_array = result.add_array()
            for photo in self.cover:
                var item = photo.to_dict(recursive=recursive)
                var copied = result.copy_subtree_from(item, item.root)
                result.append_child(cover_array, copied)
            result.object_set(result.root, "cover", cover_array)
        if self.start_timestamp is not None:
            result.set_number(
                result.root, "start_timestamp", self.start_timestamp.value().seconds_json_number()
            )
        if len(self.qualities) > 0:
            var qualities_array = result.add_array()
            for quality in self.qualities:
                var item = quality.to_dict(recursive=recursive)
                var copied = result.copy_subtree_from(item, item.root)
                result.append_child(qualities_array, copied)
            result.object_set(result.root, "qualities", qualities_array)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("Video JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Video JSON value is not an object")
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
            raise Error("Video JSON object is missing a required field")
        var file_id = data.string_value(file_id_index)
        var file_unique_id = data.string_value(file_unique_id_index)
        var width = data.integer_value(width_index)
        var height = data.integer_value(height_index)
        var duration = to_timedelta(atof(data.number_text(duration_index)))
        var mime_type: Optional[String] = None
        var mime_type_index = data.object_get(data.root, "mime_type")
        if mime_type_index != -1 and not data.is_null(mime_type_index):
            mime_type = Optional[String](data.string_value(mime_type_index))
        var file_size: Optional[Int] = None
        var file_size_index = data.object_get(data.root, "file_size")
        if file_size_index != -1 and not data.is_null(file_size_index):
            file_size = Optional[Int](data.integer_value(file_size_index))
        var file_name: Optional[String] = None
        var file_name_index = data.object_get(data.root, "file_name")
        if file_name_index != -1 and not data.is_null(file_name_index):
            file_name = Optional[String](data.string_value(file_name_index))
        var thumbnail: Optional[PhotoSize] = None
        var thumbnail_index = data.object_get(data.root, "thumbnail")
        if thumbnail_index != -1 and not data.is_null(thumbnail_index):
            var thumbnail_document = JsonDocument()
            thumbnail_document.root = thumbnail_document.copy_subtree_from(data, thumbnail_index)
            thumbnail = Optional[PhotoSize](PhotoSize.de_json(thumbnail_document))
        var cover = List[PhotoSize]()
        var cover_index = data.object_get(data.root, "cover")
        if cover_index != -1 and not data.is_null(cover_index):
            var cover_documents = data.array_documents(cover_index)
            for index in range(len(cover_documents)):
                cover.append(PhotoSize.de_json(cover_documents[index].copy()))
        var start_timestamp: Optional[TimeDelta] = None
        var start_timestamp_index = data.object_get(data.root, "start_timestamp")
        if start_timestamp_index != -1 and not data.is_null(start_timestamp_index):
            start_timestamp = Optional[TimeDelta](
                to_timedelta(atof(data.number_text(start_timestamp_index)))
            )
        var qualities = List[VideoQuality]()
        var qualities_index = data.object_get(data.root, "qualities")
        if qualities_index != -1 and not data.is_null(qualities_index):
            var quality_documents = data.array_documents(qualities_index)
            for index in range(len(quality_documents)):
                qualities.append(VideoQuality.de_json(quality_documents[index].copy()))

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
                and key != "mime_type"
                and key != "file_size"
                and key != "file_name"
                and key != "thumbnail"
                and key != "cover"
                and key != "start_timestamp"
                and key != "qualities"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        var cover_value = Optional[List[PhotoSize]](cover^)
        var qualities_value = Optional[List[VideoQuality]](qualities^)
        return Video(
            file_id,
            file_unique_id,
            width,
            height,
            duration,
            mime_type,
            file_size,
            file_name,
            thumbnail,
            cover_value,
            start_timestamp,
            qualities_value,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Video.de_json(items[index].copy()))
        return result^
