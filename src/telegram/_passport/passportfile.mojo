#!/usr/bin/env mojo
#
# Native PassportFile model corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Metadata for a file uploaded to Telegram Passport."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._passport.credentials import FileCredentials
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct PassportFile(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Telegram Passport file; equality follows ``file_unique_id``."""

    var file_id: String
    var file_unique_id: String
    var file_date: TimestampDateTime
    var file_size: Int
    var credentials: Optional[FileCredentials]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        file_date: TimestampDateTime,
        file_size: Int,
        credentials: Optional[FileCredentials] = None,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.file_date = file_date.copy()
        self.file_size = file_size
        self.credentials = credentials.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        file_id: String,
        file_unique_id: String,
        file_date: TimestampDateTime,
        file_size: Int,
        credentials: Optional[FileCredentials],
        *,
        api_kwargs: JsonDocument,
    ):
        self.file_id = file_id.copy()
        self.file_unique_id = file_unique_id.copy()
        self.file_date = file_date.copy()
        self.file_size = file_size
        self.credentials = credentials.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.file_id = existing.file_id.copy()
        self.file_unique_id = existing.file_unique_id.copy()
        self.file_date = existing.file_date.copy()
        self.file_size = existing.file_size
        self.credentials = existing.credentials.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.file_unique_id == other.file_unique_id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.file_unique_id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "file_id", self.file_id)
        result.set_string(result.root, "file_unique_id", self.file_unique_id)
        result.set_number(result.root, "file_date", String(to_timestamp(self.file_date)))
        result.set_number(result.root, "file_size", String(self.file_size))
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> PassportFile:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("PassportFile JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PassportFile JSON value is not an object")

        var file_id_index = data.object_get(data.root, "file_id")
        var file_unique_id_index = data.object_get(data.root, "file_unique_id")
        var file_date_index = data.object_get(data.root, "file_date")
        var file_size_index = data.object_get(data.root, "file_size")
        if (
            file_id_index == -1 or file_unique_id_index == -1
            or file_date_index == -1 or file_size_index == -1
        ):
            raise Error("PassportFile JSON object is missing a required field")
        if data.is_null(file_date_index) or data.is_null(file_size_index):
            raise Error("PassportFile file_date and file_size must not be null")

        var file_id = data.string_value(file_id_index)
        var file_unique_id = data.string_value(file_unique_id_index)
        var file_date = from_timestamp(data.integer_value(file_date_index))
        var file_size = data.integer_value(file_size_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "file_id" and key != "file_unique_id"
                and key != "file_date" and key != "file_size"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return PassportFile(
            file_id,
            file_unique_id,
            file_date,
            file_size,
            None,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_json_decrypted(data: JsonDocument, credentials: FileCredentials) raises -> PassportFile:
        var result = PassportFile.de_json(data)
        result.credentials = Optional[FileCredentials](credentials.copy())
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[PassportFile]:
        var items = data.array_documents(array_index)
        var result = List[PassportFile]()
        for index in range(len(items)):
            result.append(PassportFile.de_json(items[index].copy()))
        return result^

    @staticmethod
    def de_list_decrypted(
        data: JsonDocument,
        array_index: Int,
        credentials: List[FileCredentials],
    ) raises -> List[PassportFile]:
        var items = data.array_documents(array_index)
        var result = List[PassportFile]()
        if len(items) != len(credentials):
            raise Error("PassportFile list and credentials must have the same length")
        for index in range(len(items)):
            result.append(
                PassportFile.de_json_decrypted(items[index].copy(), credentials[index].copy())
            )
        return result^

