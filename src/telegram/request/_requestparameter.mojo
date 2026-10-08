#!/usr/bin/env mojo
#
# Native request parameter values corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""One Bot API request parameter, its JSON value, and upload files."""

from std.collections import List
from std.collections.optional import Optional

from telegram._files.inputfile import InputFile, UploadField
from telegram._files.inputprofilephoto import InputProfilePhoto
from telegram._files.inputstorycontent import InputStoryContent
from telegram._files.inputsticker import InputSticker
from telegram._files.inputmedia import InputMedia, InputPaidMedia
from telegram._utils.files import ParsedFileInput
from telegram._utils.json import JSON_NULL, JSON_STRING, JsonDocument, dumps_json


struct MultipartPart(Copyable):
    var name: String
    var field: UploadField
    var is_file: Bool
    var value: String

    def __init__(out self, name: String, field: UploadField):
        self.name = name.copy()
        self.field = field.copy()
        self.is_file = True
        self.value = String()

    def __init__(out self, name: String, value: String):
        self.name = name.copy()
        self.field = UploadField(String(), List[UInt8](), String())
        self.is_file = False
        self.value = value.copy()

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        self.field = existing.field.copy()
        self.is_file = existing.is_file
        self.value = existing.value.copy()


def _string_document(value: String) -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_string(value)
    return result^


def _number_document(value: String) -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_number(value)
    return result^


def _bool_document(value: Bool) -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_boolean(value)
    return result^


struct RequestParameter(Copyable):
    """A typed JSON value and any uploaded files associated with one parameter."""

    var name: String
    var value: Optional[JsonDocument]
    var input_files: List[InputFile]

    def __init__(out self, name: String, value: Optional[JsonDocument]):
        self.name = name.copy()
        if value is None:
            self.value = None
        else:
            self.value = Optional[JsonDocument](value.value().copy())
        self.input_files = List[InputFile]()

    def __init__(
        out self,
        name: String,
        value: Optional[JsonDocument],
        input_files: List[InputFile],
    ):
        self.name = name.copy()
        if value is None:
            self.value = None
        else:
            self.value = Optional[JsonDocument](value.value().copy())
        self.input_files = List[InputFile](copy=input_files)

    def __copyinit__(out self, existing: Self):
        self.name = existing.name.copy()
        if existing.value is None:
            self.value = None
        else:
            self.value = Optional[JsonDocument](existing.value.value().copy())
        self.input_files = List[InputFile](copy=existing.input_files)

    def json_value(self) raises -> Optional[String]:
        if self.value is None:
            return None
        var document = self.value.value().copy()
        if document.root < 0 or document.root >= len(document.nodes):
            raise Error("RequestParameter JSON value has no root")
        if document.nodes[document.root].kind == JSON_NULL:
            return None
        if document.nodes[document.root].kind == JSON_STRING:
            return Optional[String](document.string_value(document.root))
        return Optional[String](dumps_json(document.copy()))

    def multipart_data(self) -> List[MultipartPart]:
        var result = List[MultipartPart]()
        for file in self.input_files:
            var field_name = self.name
            if file.attach_name is not None:
                field_name = file.attach_name.value().copy()
            result.append(MultipartPart(field_name, file.field_tuple()))
        return result^

    @staticmethod
    def from_input(key: String, value: String) -> Self:
        return Self(key, Optional[JsonDocument](_string_document(value)))

    @staticmethod
    def from_input(key: String, value: Int) -> Self:
        return Self(key, Optional[JsonDocument](_number_document(String(value))))

    @staticmethod
    def from_input(key: String, value: Int64) -> Self:
        return Self(key, Optional[JsonDocument](_number_document(String(value))))

    @staticmethod
    def from_input(key: String, value: Float64) -> Self:
        return Self(key, Optional[JsonDocument](_number_document(String(value))))

    @staticmethod
    def from_input(key: String, value: Bool) -> Self:
        return Self(key, Optional[JsonDocument](_bool_document(value)))

    @staticmethod
    def from_input(key: String, value: JsonDocument) -> Self:
        return Self(key, Optional[JsonDocument](value.copy()))

    @staticmethod
    def from_input(key: String, value: InputFile) -> Self:
        var files = List[InputFile]()
        files.append(value.copy())
        if value.attach_uri is None:
            return Self(key, Optional[JsonDocument](None), files)
        return Self(
            key,
            Optional[JsonDocument](_string_document(value.attach_uri.value())),
            files,
        )

    @staticmethod
    def from_input(key: String, value: ParsedFileInput) raises -> Self:
        if value.kind == ParsedFileInput.FILE_ID:
            return Self.from_input(key, value.file_id.value())
        if value.kind == ParsedFileInput.UPLOAD:
            return Self.from_input(key, value.input_file.value())
        if value.kind == ParsedFileInput.PATH:
            raise Error("A non-local Path is not JSON-serializable as a request parameter")
        raise Error("ParsedFileInput has an unknown variant")

    @staticmethod
    def from_input(key: String, value: InputSticker) raises -> Self:
        var data = value.to_dict()
        var files = List[InputFile]()
        if value.sticker.kind == ParsedFileInput.UPLOAD:
            files.append(value.sticker.input_file.value().copy())
        elif value.sticker.kind == ParsedFileInput.PATH:
            raise Error("A non-local Path is not JSON-serializable as an InputSticker")
        return Self(key, Optional[JsonDocument](data.copy()), files)

    @staticmethod
    def from_input(key: String, value: InputProfilePhoto) raises -> Self:
        var data = value.to_dict()
        var files = List[InputFile]()
        var upload = value.upload_file()
        if upload is not None:
            files.append(upload.value().copy())
        return Self(key, Optional[JsonDocument](data.copy()), files)

    @staticmethod
    def from_input(key: String, value: InputStoryContent) raises -> Self:
        var data = value.to_dict()
        var files = List[InputFile]()
        var upload = value.upload_file()
        if upload is not None:
            files.append(upload.value().copy())
        return Self(key, Optional[JsonDocument](data.copy()), files)

    @staticmethod
    def from_input(key: String, values: List[InputFile]) raises -> Self:
        var files = List[InputFile](copy=values)
        var result = JsonDocument()
        result.root = result.add_array()
        for file in values:
            if file.attach_uri is not None:
                var child = result.add_string(file.attach_uri.value())
                result.append_child(result.root, child)
        return Self(key, Optional[JsonDocument](result^), files)

    @staticmethod
    def from_input(key: String, values: List[InputMedia]) raises -> Self:
        var result = JsonDocument()
        result.root = result.add_array()
        var files = List[InputFile]()
        for value in values:
            var item = value.to_dict()
            var child = result.copy_subtree_from(item, item.root)
            result.append_child(result.root, child)
            for file in value.upload_files():
                files.append(file.copy())
        return Self(key, Optional[JsonDocument](result^), files)

    @staticmethod
    def from_input(key: String, values: List[InputPaidMedia]) raises -> Self:
        var result = JsonDocument()
        result.root = result.add_array()
        var files = List[InputFile]()
        for value in values:
            var item = value.to_dict()
            var child = result.copy_subtree_from(item, item.root)
            result.append_child(result.root, child)
            for file in value.upload_files():
                files.append(file.copy())
        return Self(key, Optional[JsonDocument](result^), files)
