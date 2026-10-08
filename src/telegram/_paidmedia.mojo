#!/usr/bin/env mojo
#
# Native Mojo model translation of python-telegram-bot v22.8 _paidmedia.py.
# LGPL-3.0-or-later; see LICENSE.

"""Tagged paid media values and their containing Telegram models."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._files.livephoto import LivePhoto
from telegram._files.photosize import PhotoSize
from telegram._files.video import Video
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _paid_media_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _paid_media_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


def _paid_media_optional_int_text(data: JsonDocument, key: String) raises -> String:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return "none"
    return data.number_text(index)


def _paid_media_identity(data: JsonDocument, type: String) raises -> String:
    if type == "preview":
        var duration_index = data.object_get(data.root, "duration")
        var duration = String("none")
        if duration_index != -1 and not data.is_null(duration_index):
            duration = String(atof(data.number_text(duration_index)))
        return String(
            type,
            ":",
            _paid_media_optional_int_text(data, "width"),
            ":",
            _paid_media_optional_int_text(data, "height"),
            ":",
            duration,
        )
    if type == "photo":
        var index = data.object_get(data.root, "photo")
        if index == -1 or data.nodes[index].kind != JSON_ARRAY:
            raise Error("photo paid media is missing its photo array")
        var result = String("photo:")
        var child = data.nodes[index].first_child
        while child != -1:
            var id_index = data.object_get(child, "file_unique_id")
            if id_index == -1:
                raise Error("paid photo item is missing file_unique_id")
            result = String(result, data.string_value(id_index), "\0")
            child = data.nodes[child].next_sibling
        return result^
    if type == "video" or type == "live_photo":
        var key = String("video")
        if type == "live_photo":
            key = "live_photo"
        var index = data.object_get(data.root, key)
        if index == -1 or data.nodes[index].kind != JSON_OBJECT:
            raise Error("paid media is missing its nested media object")
        var id_index = data.object_get(index, "file_unique_id")
        if id_index == -1:
            raise Error("paid media object is missing file_unique_id")
        return String(type, ":", data.string_value(id_index))
    return type.copy()


def _paid_media_validate(data: JsonDocument, type: String) raises:
    if type == "preview":
        var width = data.object_get(data.root, "width")
        var height = data.object_get(data.root, "height")
        var duration = data.object_get(data.root, "duration")
        if width != -1 and not data.is_null(width):
            _ = data.integer_value(width)
        if height != -1 and not data.is_null(height):
            _ = data.integer_value(height)
        if duration != -1 and not data.is_null(duration):
            _ = atof(data.number_text(duration))
    elif type == "photo":
        var index = data.object_get(data.root, "photo")
        if index == -1 or data.nodes[index].kind != JSON_ARRAY:
            raise Error("photo paid media is missing its photo array")
        var items = data.array_documents(index)
        for item in items:
            _ = PhotoSize.de_json(item)
    elif type == "video":
        var index = data.object_get(data.root, "video")
        if index == -1 or data.is_null(index):
            raise Error("video paid media is missing video")
        _ = Video.de_json(_paid_media_nested(data, index))
    elif type == "live_photo":
        var index = data.object_get(data.root, "live_photo")
        if index == -1 or data.is_null(index):
            raise Error("live_photo paid media is missing live_photo")
        _ = LivePhoto.de_json(_paid_media_nested(data, index))


struct PaidMedia(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native tagged value for preview, photo, video, and live-photo media."""

    comptime PREVIEW = "preview"
    comptime PHOTO = "photo"
    comptime VIDEO = "video"
    comptime LIVE_PHOTO = "live_photo"

    var type: String
    var fields: JsonDocument
    var identity: String

    def __init__(out self, data: JsonDocument) raises:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PaidMedia JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        if type_index == -1 or data.is_null(type_index):
            raise Error("PaidMedia JSON object is missing type")
        var media_type = data.string_value(type_index)
        _paid_media_validate(data, media_type)
        self.type = media_type.copy()
        self.fields = data.copy()
        self.identity = _paid_media_identity(data, media_type)

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.fields = existing.fields.copy()
        self.identity = existing.identity.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.identity == other.identity

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.identity.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.fields.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def field(self, key: String) raises -> Optional[JsonDocument]:
        var index = self.fields.object_get(self.fields.root, key)
        if index == -1 or self.fields.is_null(index):
            return None
        return Optional[JsonDocument](_paid_media_nested(self.fields, index))

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        return Self(data)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^

    @staticmethod
    def preview(
        width: Optional[Int] = None,
        height: Optional[Int] = None,
        duration: Optional[TimeDelta] = None,
    ) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.PREVIEW)
        if width is not None:
            result.set_number(result.root, "width", String(width.value()))
        if height is not None:
            result.set_number(result.root, "height", String(height.value()))
        if duration is not None:
            result.set_number(
                result.root, "duration", duration.value().seconds_json_number()
            )
        return Self(result)

    @staticmethod
    def photo(photo: List[PhotoSize]) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.PHOTO)
        var photo_array = result.add_array()
        for item in photo:
            var item_document = item.to_dict()
            var index = result.copy_subtree_from(item_document, item_document.root)
            result.append_child(photo_array, index)
        result.object_set(result.root, "photo", photo_array)
        return Self(result)

    @staticmethod
    def video(video: Video) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.VIDEO)
        var video_document = video.to_dict()
        var index = result.copy_subtree_from(video_document, video_document.root)
        result.object_set(result.root, "video", index)
        return Self(result)

    @staticmethod
    def live_photo(live_photo: LivePhoto) raises -> Self:
        var result = empty_json_object()
        result.set_string(result.root, "type", Self.LIVE_PHOTO)
        var media_document = live_photo.to_dict()
        var index = result.copy_subtree_from(media_document, media_document.root)
        result.object_set(result.root, "live_photo", index)
        return Self(result)


struct PaidMediaInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The paid media and Star price attached to a message."""

    var star_count: Int
    var paid_media: List[PaidMedia]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        star_count: Int,
        paid_media: List[PaidMedia],
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.star_count = star_count
        self.paid_media = List[PaidMedia](copy=paid_media)
        self.api_kwargs = _paid_media_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.star_count = existing.star_count
        self.paid_media = List[PaidMedia](copy=existing.paid_media)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.star_count != other.star_count or len(self.paid_media) != len(other.paid_media):
            return False
        for index in range(len(self.paid_media)):
            if self.paid_media[index] != other.paid_media[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.star_count).as_bytes())
        for media in self.paid_media:
            hasher.update(media.identity.as_bytes())
            hasher.update(String("\0").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var media_array = result.add_array()
        for media in self.paid_media:
            var item = media.to_dict(recursive)
            var index = result.copy_subtree_from(item, item.root)
            result.append_child(media_array, index)
        result.object_set(result.root, "paid_media", media_array)
        result.set_number(result.root, "star_count", String(self.star_count))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PaidMediaInfo JSON value must be an object")
        var count_index = data.object_get(data.root, "star_count")
        if count_index == -1:
            raise Error("PaidMediaInfo JSON object is missing star_count")
        var media = List[PaidMedia]()
        var media_index = data.object_get(data.root, "paid_media")
        if media_index != -1 and not data.is_null(media_index):
            if data.nodes[media_index].kind != JSON_ARRAY:
                raise Error("PaidMediaInfo paid_media must be an array")
            var items = data.array_documents(media_index)
            for item in items:
                media.append(PaidMedia.de_json(item))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "star_count" and key != "paid_media":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            data.integer_value(count_index),
            media,
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^


struct PaidMediaPurchased(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A record of a user's purchase of paid media."""

    var from_user: User
    var paid_media_payload: String
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        from_user: User,
        paid_media_payload: String,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.from_user = from_user.copy()
        self.paid_media_payload = paid_media_payload.copy()
        self.api_kwargs = _paid_media_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.from_user = existing.from_user.copy()
        self.paid_media_payload = existing.paid_media_payload.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.from_user == other.from_user and self.paid_media_payload == other.paid_media_payload

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.from_user.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.paid_media_payload.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var from_user = self.from_user.to_dict(recursive)
        var user_index = result.copy_subtree_from(from_user, from_user.root)
        result.object_set(result.root, "from", user_index)
        result.set_string(result.root, "paid_media_payload", self.paid_media_payload)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PaidMediaPurchased JSON value must be an object")
        var user_index = data.object_get(data.root, "from")
        var payload_index = data.object_get(data.root, "paid_media_payload")
        if user_index == -1 or payload_index == -1:
            raise Error("PaidMediaPurchased JSON object is missing a required field")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "from" and key != "paid_media_payload":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            User.de_json(_paid_media_nested(data, user_index)),
            data.string_value(payload_index),
            api_kwargs=Optional[JsonDocument](api_kwargs.copy()),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
