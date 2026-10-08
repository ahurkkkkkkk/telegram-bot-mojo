#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 UserProfileAudios.
# LGPL-3.0-or-later; see LICENSE.

"""A page of audio tracks displayed on a Telegram user's profile."""

from std.collections import List
from std.hashlib.hasher import Hasher

from telegram._files.audio import Audio
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _profile_audios_equal(left: List[Audio], right: List[Audio]) -> Bool:
    if len(left) != len(right):
        return False
    for index in range(len(left)):
        if left[index] != right[index]:
            return False
    return True


struct UserProfileAudios(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A profile audio page, identified by count and ordered audio list."""

    var total_count: Int
    var audios: List[Audio]
    var api_kwargs: JsonDocument

    def __init__(out self, total_count: Int, audios: List[Audio]):
        self.total_count = total_count
        self.audios = List[Audio](copy=audios)
        self.api_kwargs = empty_json_object()

    def __init__(out self, total_count: Int, audios: List[Audio], *, api_kwargs: JsonDocument):
        self.total_count = total_count
        self.audios = List[Audio](copy=audios)
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.total_count = existing.total_count
        self.audios = List[Audio](copy=existing.audios)
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.total_count == other.total_count and _profile_audios_equal(
            self.audios, other.audios
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.total_count).as_bytes())
        for audio in self.audios:
            hasher.update(String("\0").as_bytes())
            hasher.update(audio.file_unique_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "total_count", String(self.total_count))
        var audios_array = result.add_array()
        for audio in self.audios:
            var item = audio.to_dict(recursive=recursive)
            var copied = result.copy_subtree_from(item, item.root)
            result.append_child(audios_array, copied)
        result.object_set(result.root, "audios", audios_array)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("UserProfileAudios JSON value is not an object")
        var total_count_index = data.object_get(data.root, "total_count")
        var audios_index = data.object_get(data.root, "audios")
        if total_count_index == -1:
            raise Error("UserProfileAudios JSON object is missing total_count")
        var total_count = data.integer_value(total_count_index)
        var audios = List[Audio]()
        if audios_index != -1 and not data.is_null(audios_index):
            var audio_documents = data.array_documents(audios_index)
            for index in range(len(audio_documents)):
                audios.append(Audio.de_json(audio_documents[index].copy()))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "total_count" and key != "audios":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return UserProfileAudios(total_count, audios, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(UserProfileAudios.de_json(items[index].copy()))
        return result^
