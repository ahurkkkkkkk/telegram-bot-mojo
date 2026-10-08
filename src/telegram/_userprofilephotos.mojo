#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 UserProfilePhotos.
# LGPL-3.0-or-later; see LICENSE.

"""The available profile photos for a Telegram user."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._files.photosize import PhotoSize
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _profile_photo_rows_equal(left: List[List[PhotoSize]], right: List[List[PhotoSize]]) -> Bool:
    if len(left) != len(right):
        return False
    for row in range(len(left)):
        if len(left[row]) != len(right[row]):
            return False
        for column in range(len(left[row])):
            if left[row][column] != right[row][column]:
                return False
    return True


struct UserProfilePhotos(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A page of profile photo groups, each group containing available sizes."""

    var total_count: Int
    var photos: List[List[PhotoSize]]
    var api_kwargs: JsonDocument

    def __init__(out self, total_count: Int, photos: List[List[PhotoSize]]):
        self.total_count = total_count
        self.photos = List[List[PhotoSize]]()
        for row in photos:
            self.photos.append(List[PhotoSize](copy=row))
        self.api_kwargs = empty_json_object()

    def __init__(
        out self, total_count: Int, photos: List[List[PhotoSize]], *, api_kwargs: JsonDocument
    ):
        self.total_count = total_count
        self.photos = List[List[PhotoSize]]()
        for row in photos:
            self.photos.append(List[PhotoSize](copy=row))
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.total_count = existing.total_count
        self.photos = List[List[PhotoSize]]()
        for row in existing.photos:
            self.photos.append(List[PhotoSize](copy=row))
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.total_count == other.total_count and _profile_photo_rows_equal(
            self.photos, other.photos
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.total_count).as_bytes())
        for row in self.photos:
            hasher.update(String("\0").as_bytes())
            for photo in row:
                hasher.update(photo.file_unique_id.as_bytes())
                hasher.update(String("\0").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "total_count", String(self.total_count))
        var photos_array = result.add_array()
        for row in self.photos:
            var row_array = result.add_array()
            for photo in row:
                var item = photo.to_dict(recursive=recursive)
                var copied = result.copy_subtree_from(item, item.root)
                result.append_child(row_array, copied)
            result.append_child(photos_array, row_array)
        result.object_set(result.root, "photos", photos_array)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UserProfilePhotos JSON value is not an object")
        var total_count_index = data.object_get(data.root, "total_count")
        var photos_index = data.object_get(data.root, "photos")
        if total_count_index == -1 or photos_index == -1:
            raise Error("UserProfilePhotos JSON object is missing a required field")
        var total_count = data.integer_value(total_count_index)
        var photos = List[List[PhotoSize]]()
        var photo_rows = data.array_documents(photos_index)
        for row_index in range(len(photo_rows)):
            var row = List[PhotoSize]()
            var sizes = photo_rows[row_index].array_documents(photo_rows[row_index].root)
            for size_index in range(len(sizes)):
                row.append(PhotoSize.de_json(sizes[size_index].copy()))
            photos.append(row^)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "total_count" and key != "photos":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return UserProfilePhotos(total_count, photos, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(UserProfilePhotos.de_json(items[index].copy()))
        return result^
