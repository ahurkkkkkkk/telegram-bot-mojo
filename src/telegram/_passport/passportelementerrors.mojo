#!/usr/bin/env mojo
#
# Native Passport element errors corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Typed tagged values for all Telegram Passport element error variants."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _passport_error_string(data: JsonDocument, key: String, required: Bool = False) raises -> String:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        if required:
            raise Error(String("PassportElementError is missing required field: ", key))
        return String()
    return data.string_value(index)


def _passport_error_strings(data: JsonDocument, key: String) raises -> List[String]:
    var result = List[String]()
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return result^
    if data.nodes[index].kind != JSON_ARRAY:
        raise Error(String("PassportElementError field must be an array: ", key))
    var child = data.nodes[index].first_child
    while child != -1:
        if data.nodes[child].kind != JSON_STRING:
            raise Error(String("PassportElementError array must contain strings: ", key))
        result.append(data.nodes[child].text.copy())
        child = data.nodes[child].next_sibling
    return result^


struct PassportElementError(Equatable, Hashable, Copyable, TelegramJsonObject):
    """One Passport error variant with common source, type, message, and variant details."""

    comptime BASE = 0
    comptime DATA_FIELD = 1
    comptime FILE = 2
    comptime FILES = 3
    comptime FRONT_SIDE = 4
    comptime REVERSE_SIDE = 5
    comptime SELFIE = 6
    comptime TRANSLATION_FILE = 7
    comptime TRANSLATION_FILES = 8
    comptime UNSPECIFIED = 9

    var kind: Int
    var source: String
    var type: String
    var message: String
    var field_name: String
    var data_hash: String
    var file_hash: String
    var file_hashes: List[String]
    var element_hash: String
    var api_kwargs: JsonDocument

    def __init__(out self, source: String, type: String, message: String):
        self.kind = Self.BASE
        self.source = source.copy()
        self.type = type.copy()
        self.message = message.copy()
        self.field_name = String()
        self.data_hash = String()
        self.file_hash = String()
        self.file_hashes = List[String]()
        self.element_hash = String()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        source: String,
        type: String,
        message: String,
        *,
        api_kwargs: JsonDocument,
    ):
        self.kind = Self.BASE
        self.source = source.copy()
        self.type = type.copy()
        self.message = message.copy()
        self.field_name = String()
        self.data_hash = String()
        self.file_hash = String()
        self.file_hashes = List[String]()
        self.element_hash = String()
        self.api_kwargs = api_kwargs.copy()

    def __init__(
        out self,
        kind: Int,
        source: String,
        type: String,
        message: String,
        field_name: String,
        data_hash: String,
        file_hash: String,
        file_hashes: List[String],
        element_hash: String,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.kind = kind
        self.source = source.copy()
        self.type = type.copy()
        self.message = message.copy()
        self.field_name = field_name.copy()
        self.data_hash = data_hash.copy()
        self.file_hash = file_hash.copy()
        self.file_hashes = file_hashes.copy()
        self.element_hash = element_hash.copy()
        if api_kwargs is None:
            self.api_kwargs = empty_json_object()
        else:
            self.api_kwargs = api_kwargs.value().copy()

    def __copyinit__(out self, existing: Self):
        self.kind = existing.kind
        self.source = existing.source.copy()
        self.type = existing.type.copy()
        self.message = existing.message.copy()
        self.field_name = existing.field_name.copy()
        self.data_hash = existing.data_hash.copy()
        self.file_hash = existing.file_hash.copy()
        self.file_hashes = existing.file_hashes.copy()
        self.element_hash = existing.element_hash.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.kind != other.kind or self.source != other.source or self.type != other.type:
            return False
        if self.kind == Self.BASE:
            return True
        if self.message != other.message:
            return False
        if self.kind == Self.DATA_FIELD:
            return self.field_name == other.field_name and self.data_hash == other.data_hash
        if self.kind == Self.FILES or self.kind == Self.TRANSLATION_FILES:
            if len(self.file_hashes) != len(other.file_hashes):
                return False
            for index in range(len(self.file_hashes)):
                if self.file_hashes[index] != other.file_hashes[index]:
                    return False
            return True
        if self.kind == Self.UNSPECIFIED:
            return self.element_hash == other.element_hash
        return self.file_hash == other.file_hash

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.kind).as_bytes())
        hasher.update(self.source.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.type.as_bytes())
        if self.kind == Self.BASE:
            return
        hasher.update(String("\0").as_bytes())
        hasher.update(self.message.as_bytes())
        if self.kind == Self.DATA_FIELD:
            hasher.update(self.field_name.as_bytes())
            hasher.update(self.data_hash.as_bytes())
        elif self.kind == Self.FILES or self.kind == Self.TRANSLATION_FILES:
            for value in self.file_hashes:
                hasher.update(value.as_bytes())
                hasher.update(String("\0").as_bytes())
        elif self.kind == Self.UNSPECIFIED:
            hasher.update(self.element_hash.as_bytes())
        else:
            hasher.update(self.file_hash.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "source", self.source)
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "message", self.message)
        if self.kind == Self.DATA_FIELD:
            result.set_string(result.root, "field_name", self.field_name)
            result.set_string(result.root, "data_hash", self.data_hash)
        elif self.kind == Self.FILES or self.kind == Self.TRANSLATION_FILES:
            if len(self.file_hashes) > 0:
                var values = result.add_array()
                for value in self.file_hashes:
                    var child = result.add_string(value)
                    result.append_child(values, child)
                result.object_set(result.root, "file_hashes", values)
        elif self.kind == Self.UNSPECIFIED:
            result.set_string(result.root, "element_hash", self.element_hash)
        elif self.kind != Self.BASE:
            result.set_string(result.root, "file_hash", self.file_hash)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> PassportElementError:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PassportElementError JSON value must be an object")
        var source = _passport_error_string(data, "source", True)
        var type = _passport_error_string(data, "type", True)
        var message = _passport_error_string(data, "message", True)
        var kind = Self.BASE
        var field_name = String()
        var data_hash = String()
        var file_hash = String()
        var file_hashes = List[String]()
        var element_hash = String()
        if source == "data":
            kind = Self.DATA_FIELD
            field_name = _passport_error_string(data, "field_name", True)
            data_hash = _passport_error_string(data, "data_hash", True)
        elif source == "file":
            kind = Self.FILE
            file_hash = _passport_error_string(data, "file_hash", True)
        elif source == "files":
            kind = Self.FILES
            file_hashes = _passport_error_strings(data, "file_hashes")
        elif source == "front_side":
            kind = Self.FRONT_SIDE
            file_hash = _passport_error_string(data, "file_hash", True)
        elif source == "reverse_side":
            kind = Self.REVERSE_SIDE
            file_hash = _passport_error_string(data, "file_hash", True)
        elif source == "selfie":
            kind = Self.SELFIE
            file_hash = _passport_error_string(data, "file_hash", True)
        elif source == "translation_file":
            kind = Self.TRANSLATION_FILE
            file_hash = _passport_error_string(data, "file_hash", True)
        elif source == "translation_files":
            kind = Self.TRANSLATION_FILES
            file_hashes = _passport_error_strings(data, "file_hashes")
        elif source == "unspecified":
            kind = Self.UNSPECIFIED
            element_hash = _passport_error_string(data, "element_hash", True)
        var known = List[String]()
        known.append("source")
        known.append("type")
        known.append("message")
        known.append("field_name")
        known.append("data_hash")
        known.append("file_hash")
        known.append("file_hashes")
        known.append("element_hash")
        var extra = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var is_known = False
            for known_key in known:
                if key == known_key:
                    is_known = True
                    break
            if not is_known:
                var copied = extra.copy_subtree_from(data, child)
                extra.object_set(extra.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return PassportElementError(
            kind,
            source,
            type,
            message,
            field_name,
            data_hash,
            file_hash,
            file_hashes,
            element_hash,
            Optional[JsonDocument](extra^),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[PassportElementError]:
        var items = data.array_documents(array_index)
        var result = List[PassportElementError]()
        for item in items:
            result.append(PassportElementError.de_json(item.copy()))
        return result^


def PassportElementErrorDataField(
    type: String,
    field_name: String,
    data_hash: String,
    message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.DATA_FIELD, "data", type, message, field_name, data_hash,
        String(), List[String](), String(), api_kwargs
    )


def PassportElementErrorFile(
    type: String, file_hash: String, message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.FILE, "file", type, message, String(), String(), file_hash,
        List[String](), String(), api_kwargs
    )


def PassportElementErrorFiles(
    type: String, file_hashes: List[String], message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.FILES, "files", type, message, String(), String(), String(),
        file_hashes, String(), api_kwargs
    )


def PassportElementErrorFrontSide(
    type: String, file_hash: String, message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.FRONT_SIDE, "front_side", type, message, String(), String(),
        file_hash, List[String](), String(), api_kwargs
    )


def PassportElementErrorReverseSide(
    type: String, file_hash: String, message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.REVERSE_SIDE, "reverse_side", type, message, String(), String(),
        file_hash, List[String](), String(), api_kwargs
    )


def PassportElementErrorSelfie(
    type: String, file_hash: String, message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.SELFIE, "selfie", type, message, String(), String(), file_hash,
        List[String](), String(), api_kwargs
    )


def PassportElementErrorTranslationFile(
    type: String, file_hash: String, message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.TRANSLATION_FILE, "translation_file", type, message, String(),
        String(), file_hash, List[String](), String(), api_kwargs
    )


def PassportElementErrorTranslationFiles(
    type: String, file_hashes: List[String], message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.TRANSLATION_FILES, "translation_files", type, message, String(),
        String(), String(), file_hashes, String(), api_kwargs
    )


def PassportElementErrorUnspecified(
    type: String, element_hash: String, message: String,
    api_kwargs: Optional[JsonDocument] = None,
) -> PassportElementError:
    return PassportElementError(
        PassportElementError.UNSPECIFIED, "unspecified", type, message, String(), String(),
        String(), List[String](), element_hash, api_kwargs
    )
