#!/usr/bin/env mojo
#
# Native translation slice of python-telegram-bot v22.8 sticker.py.
# LGPL-3.0-or-later; see LICENSE.

"""Sticker-related values; MaskPosition is implemented here."""

from std.hashlib.hasher import Hasher
from std.collections import List
from std.collections.optional import Optional

from telegram import constants
from telegram._files.file import File
from telegram._files.photosize import PhotoSize
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct MaskPosition(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The face-relative position and scale of a mask sticker."""

    comptime FOREHEAD = constants.MaskPosition.FOREHEAD.value
    comptime EYES = constants.MaskPosition.EYES.value
    comptime MOUTH = constants.MaskPosition.MOUTH.value
    comptime CHIN = constants.MaskPosition.CHIN.value

    var point: String
    var x_shift: Float64
    var y_shift: Float64
    var scale: Float64
    var api_kwargs: JsonDocument

    def __init__(out self, point: String, x_shift: Float64, y_shift: Float64, scale: Float64):
        self.point = point.copy()
        self.x_shift = x_shift
        self.y_shift = y_shift
        self.scale = scale
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        point: String,
        x_shift: Float64,
        y_shift: Float64,
        scale: Float64,
        *,
        api_kwargs: JsonDocument,
    ):
        self.point = point.copy()
        self.x_shift = x_shift
        self.y_shift = y_shift
        self.scale = scale
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.point = existing.point.copy()
        self.x_shift = existing.x_shift
        self.y_shift = existing.y_shift
        self.scale = existing.scale
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.point == other.point
            and self.x_shift == other.x_shift
            and self.y_shift == other.y_shift
            and self.scale == other.scale
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.point.as_bytes())
        hasher.update(String("\0").as_bytes())
        var x_text = String(self.x_shift)
        if self.x_shift == 0.0:
            x_text = "0"
        var y_text = String(self.y_shift)
        if self.y_shift == 0.0:
            y_text = "0"
        var scale_text = String(self.scale)
        if self.scale == 0.0:
            scale_text = "0"
        hasher.update(x_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(y_text.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(scale_text.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "point", self.point)
        result.set_number(result.root, "x_shift", String(self.x_shift))
        result.set_number(result.root, "y_shift", String(self.y_shift))
        result.set_number(result.root, "scale", String(self.scale))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("MaskPosition JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("MaskPosition JSON value is not an object")
        var point_index = data.object_get(data.root, "point")
        var x_shift_index = data.object_get(data.root, "x_shift")
        var y_shift_index = data.object_get(data.root, "y_shift")
        var scale_index = data.object_get(data.root, "scale")
        if point_index == -1 or x_shift_index == -1 or y_shift_index == -1 or scale_index == -1:
            raise Error("MaskPosition JSON object is missing a required field")
        var point = data.string_value(point_index)
        var x_shift = atof(data.number_text(x_shift_index))
        var y_shift = atof(data.number_text(y_shift_index))
        var scale = atof(data.number_text(scale_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "point" and key != "x_shift" and key != "y_shift" and key != "scale":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return MaskPosition(point, x_shift, y_shift, scale, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(MaskPosition.de_json(items[index].copy()))
        return result^


struct Sticker(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Telegram sticker with type, format, and optional associated metadata."""

    comptime REGULAR = constants.StickerType.REGULAR.value
    comptime MASK = constants.StickerType.MASK.value
    comptime CUSTOM_EMOJI = constants.StickerType.CUSTOM_EMOJI.value

    var file_id: String
    var file_unique_id: String
    var width: Int
    var height: Int
    var is_animated: Bool
    var is_video: Bool
    var type: String
    var emoji: Optional[String]
    var file_size: Optional[Int]
    var set_name: Optional[String]
    var mask_position: Optional[MaskPosition]
    var premium_animation: Optional[File]
    var custom_emoji_id: Optional[String]
    var thumbnail: Optional[PhotoSize]
    var needs_repainting: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        width: Int,
        height: Int,
        is_animated: Bool,
        is_video: Bool,
        type: String,
        emoji: Optional[String] = None,
        file_size: Optional[Int] = None,
        set_name: Optional[String] = None,
        mask_position: Optional[MaskPosition] = None,
        premium_animation: Optional[File] = None,
        custom_emoji_id: Optional[String] = None,
        thumbnail: Optional[PhotoSize] = None,
        needs_repainting: Optional[Bool] = None,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.width = width
        self.height = height
        self.is_animated = is_animated
        self.is_video = is_video
        self.type = type.copy()
        self.emoji = emoji
        self.file_size = file_size
        self.set_name = set_name
        self.mask_position = mask_position.copy()
        self.premium_animation = premium_animation.copy()
        self.custom_emoji_id = custom_emoji_id
        self.thumbnail = thumbnail.copy()
        self.needs_repainting = needs_repainting
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        width: Int,
        height: Int,
        is_animated: Bool,
        is_video: Bool,
        type: String,
        emoji: Optional[String] = None,
        file_size: Optional[Int] = None,
        set_name: Optional[String] = None,
        mask_position: Optional[MaskPosition] = None,
        premium_animation: Optional[File] = None,
        custom_emoji_id: Optional[String] = None,
        thumbnail: Optional[PhotoSize] = None,
        needs_repainting: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.width = width
        self.height = height
        self.is_animated = is_animated
        self.is_video = is_video
        self.type = type.copy()
        self.emoji = emoji
        self.file_size = file_size
        self.set_name = set_name
        self.mask_position = mask_position.copy()
        self.premium_animation = premium_animation.copy()
        self.custom_emoji_id = custom_emoji_id
        self.thumbnail = thumbnail.copy()
        self.needs_repainting = needs_repainting
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.file_id = existing.file_id.copy()
        self.file_unique_id = existing.file_unique_id.copy()
        self.width = existing.width
        self.height = existing.height
        self.is_animated = existing.is_animated
        self.is_video = existing.is_video
        self.type = existing.type.copy()
        self.emoji = existing.emoji
        self.file_size = existing.file_size
        self.set_name = existing.set_name
        self.mask_position = existing.mask_position.copy()
        self.premium_animation = existing.premium_animation.copy()
        self.custom_emoji_id = existing.custom_emoji_id
        self.thumbnail = existing.thumbnail.copy()
        self.needs_repainting = existing.needs_repainting
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
        result.set_boolean(result.root, "is_animated", self.is_animated)
        result.set_boolean(result.root, "is_video", self.is_video)
        result.set_string(result.root, "type", self.type)
        if self.emoji is not None:
            result.set_string(result.root, "emoji", self.emoji.value())
        if self.file_size is not None:
            result.set_number(result.root, "file_size", String(self.file_size.value()))
        if self.set_name is not None:
            result.set_string(result.root, "set_name", self.set_name.value())
        if self.mask_position is not None:
            var mask_position = self.mask_position.value().to_dict(recursive=recursive)
            var mask_node = result.copy_subtree_from(mask_position, mask_position.root)
            result.object_set(result.root, "mask_position", mask_node)
        if self.premium_animation is not None:
            var premium_animation = self.premium_animation.value().to_dict(recursive=recursive)
            var premium_node = result.copy_subtree_from(premium_animation, premium_animation.root)
            result.object_set(result.root, "premium_animation", premium_node)
        if self.custom_emoji_id is not None:
            result.set_string(result.root, "custom_emoji_id", self.custom_emoji_id.value())
        if self.thumbnail is not None:
            var thumbnail = self.thumbnail.value().to_dict(recursive=recursive)
            var thumbnail_node = result.copy_subtree_from(thumbnail, thumbnail.root)
            result.object_set(result.root, "thumbnail", thumbnail_node)
        if self.needs_repainting is not None:
            result.set_boolean(result.root, "needs_repainting", self.needs_repainting.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Sticker JSON value is not an object")
        var file_id_index = data.object_get(data.root, "file_id")
        var file_unique_id_index = data.object_get(data.root, "file_unique_id")
        var width_index = data.object_get(data.root, "width")
        var height_index = data.object_get(data.root, "height")
        var animated_index = data.object_get(data.root, "is_animated")
        var video_index = data.object_get(data.root, "is_video")
        var type_index = data.object_get(data.root, "type")
        if (
            file_id_index == -1
            or file_unique_id_index == -1
            or width_index == -1
            or height_index == -1
            or animated_index == -1
            or video_index == -1
            or type_index == -1
        ):
            raise Error("Sticker JSON object is missing a required field")
        var file_id = data.string_value(file_id_index)
        var file_unique_id = data.string_value(file_unique_id_index)
        var width = data.integer_value(width_index)
        var height = data.integer_value(height_index)
        var is_animated = data.boolean_value(animated_index)
        var is_video = data.boolean_value(video_index)
        var sticker_type = data.string_value(type_index)
        var emoji: Optional[String] = None
        var emoji_index = data.object_get(data.root, "emoji")
        if emoji_index != -1 and not data.is_null(emoji_index):
            emoji = Optional[String](data.string_value(emoji_index))
        var file_size: Optional[Int] = None
        var file_size_index = data.object_get(data.root, "file_size")
        if file_size_index != -1 and not data.is_null(file_size_index):
            file_size = Optional[Int](data.integer_value(file_size_index))
        var set_name: Optional[String] = None
        var set_name_index = data.object_get(data.root, "set_name")
        if set_name_index != -1 and not data.is_null(set_name_index):
            set_name = Optional[String](data.string_value(set_name_index))
        var mask_position: Optional[MaskPosition] = None
        var mask_index = data.object_get(data.root, "mask_position")
        if mask_index != -1 and not data.is_null(mask_index):
            var mask_document = JsonDocument()
            mask_document.root = mask_document.copy_subtree_from(data, mask_index)
            mask_position = Optional[MaskPosition](MaskPosition.de_json(mask_document))
        var premium_animation: Optional[File] = None
        var premium_index = data.object_get(data.root, "premium_animation")
        if premium_index != -1 and not data.is_null(premium_index):
            var premium_document = JsonDocument()
            premium_document.root = premium_document.copy_subtree_from(data, premium_index)
            premium_animation = Optional[File](File.de_json(premium_document))
        var custom_emoji_id: Optional[String] = None
        var custom_emoji_index = data.object_get(data.root, "custom_emoji_id")
        if custom_emoji_index != -1 and not data.is_null(custom_emoji_index):
            custom_emoji_id = Optional[String](data.string_value(custom_emoji_index))
        var thumbnail: Optional[PhotoSize] = None
        var thumbnail_index = data.object_get(data.root, "thumbnail")
        if thumbnail_index != -1 and not data.is_null(thumbnail_index):
            var thumbnail_document = JsonDocument()
            thumbnail_document.root = thumbnail_document.copy_subtree_from(data, thumbnail_index)
            thumbnail = Optional[PhotoSize](PhotoSize.de_json(thumbnail_document))
        var needs_repainting: Optional[Bool] = None
        var repainting_index = data.object_get(data.root, "needs_repainting")
        if repainting_index != -1 and not data.is_null(repainting_index):
            needs_repainting = Optional[Bool](data.boolean_value(repainting_index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "file_id"
                and key != "file_unique_id"
                and key != "width"
                and key != "height"
                and key != "is_animated"
                and key != "is_video"
                and key != "type"
                and key != "emoji"
                and key != "file_size"
                and key != "set_name"
                and key != "mask_position"
                and key != "premium_animation"
                and key != "custom_emoji_id"
                and key != "thumbnail"
                and key != "needs_repainting"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Sticker(
            file_id,
            file_unique_id,
            width,
            height,
            is_animated,
            is_video,
            sticker_type,
            emoji,
            file_size,
            set_name,
            mask_position,
            premium_animation,
            custom_emoji_id,
            thumbnail,
            needs_repainting,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Sticker.de_json(items[index].copy()))
        return result^


def _stickers_equal(left: List[Sticker], right: List[Sticker]) -> Bool:
    if len(left) != len(right):
        return False
    for index in range(len(left)):
        if left[index] != right[index]:
            return False
    return True


struct StickerSet(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A named Telegram sticker collection."""

    var name: String
    var title: String
    var stickers: List[Sticker]
    var sticker_type: String
    var thumbnail: Optional[PhotoSize]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        name: String,
        title: String,
        stickers: List[Sticker],
        sticker_type: String,
        thumbnail: Optional[PhotoSize] = None,
    ):
        self.name = name.copy()
        self.title = title.copy()
        self.stickers = List[Sticker](copy=stickers)
        self.sticker_type = sticker_type.copy()
        self.thumbnail = thumbnail.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        name: String,
        title: String,
        stickers: List[Sticker],
        sticker_type: String,
        thumbnail: Optional[PhotoSize] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.name = name.copy()
        self.title = title.copy()
        self.stickers = List[Sticker](copy=stickers)
        self.sticker_type = sticker_type.copy()
        self.thumbnail = thumbnail.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.title = existing.title.copy()
        self.stickers = List[Sticker](copy=existing.stickers)
        self.sticker_type = existing.sticker_type.copy()
        self.thumbnail = existing.thumbnail.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.name == other.name

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.name.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "name", self.name)
        result.set_string(result.root, "title", self.title)
        var stickers_array = result.add_array()
        for sticker in self.stickers:
            var item = sticker.to_dict(recursive=recursive)
            var copied = result.copy_subtree_from(item, item.root)
            result.append_child(stickers_array, copied)
        result.object_set(result.root, "stickers", stickers_array)
        result.set_string(result.root, "sticker_type", self.sticker_type)
        if self.thumbnail is not None:
            var thumbnail = self.thumbnail.value().to_dict(recursive=recursive)
            var thumbnail_node = result.copy_subtree_from(thumbnail, thumbnail.root)
            result.object_set(result.root, "thumbnail", thumbnail_node)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("StickerSet JSON value is not an object")
        var name_index = data.object_get(data.root, "name")
        var title_index = data.object_get(data.root, "title")
        var stickers_index = data.object_get(data.root, "stickers")
        var sticker_type_index = data.object_get(data.root, "sticker_type")
        if name_index == -1 or title_index == -1 or stickers_index == -1 or sticker_type_index == -1:
            raise Error("StickerSet JSON object is missing a required field")
        var name = data.string_value(name_index)
        var title = data.string_value(title_index)
        var sticker_type = data.string_value(sticker_type_index)
        var stickers = List[Sticker]()
        var sticker_documents = data.array_documents(stickers_index)
        for index in range(len(sticker_documents)):
            stickers.append(Sticker.de_json(sticker_documents[index].copy()))
        var thumbnail: Optional[PhotoSize] = None
        var thumbnail_index = data.object_get(data.root, "thumbnail")
        if thumbnail_index != -1 and not data.is_null(thumbnail_index):
            var thumbnail_document = JsonDocument()
            thumbnail_document.root = thumbnail_document.copy_subtree_from(data, thumbnail_index)
            thumbnail = Optional[PhotoSize](PhotoSize.de_json(thumbnail_document))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "name" and key != "title" and key != "stickers" and key != "sticker_type" and key != "thumbnail":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return StickerSet(name, title, stickers, sticker_type, thumbnail, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(StickerSet.de_json(items[index].copy()))
        return result^
