#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _files/inputsticker.py.
# LGPL-3.0-or-later; see LICENSE.

"""Sticker upload input with Bot API request serialization."""

from std.collections import List
from std.collections.optional import Optional

from std.pathlib import Path

from telegram._files.inputfile import InputFile
from telegram._files.sticker import MaskPosition
from telegram._utils.argumentparsing import parse_sequence_arg
from telegram._utils.files import ParsedFileInput, parse_file_input
from telegram._utils.json import JSON_NULL, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _copy_optional_json(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


def _append_strings(mut document: JsonDocument, key: String, values: List[String]) raises:
    if len(values) == 0:
        return
    var array = document.add_array()
    for value in values:
        var item = document.add_string(value)
        document.append_child(array, item)
    document.object_set(document.root, key, array)


struct InputSticker(Copyable):
    """A sticker upload request value.

    File inputs are classified by ``parse_file_input`` in local mode with
    multipart attachment enabled, matching the upstream constructor. The
    sequence fields are copied into native lists because Mojo has no dynamic
    ``collections.abc.Sequence`` equivalent or immutable variable-length tuple.
    """

    var sticker: ParsedFileInput
    var emoji_list: List[String]
    var format: String
    var mask_position: Optional[MaskPosition]
    var keywords: List[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        sticker: ParsedFileInput,
        emoji_list: List[String],
        format: String,
        mask_position: Optional[MaskPosition] = None,
        keywords: Optional[List[String]] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.sticker = sticker.copy()
        self.emoji_list = parse_sequence_arg(emoji_list)
        self.format = format.copy()
        self.mask_position = mask_position.copy()
        self.keywords = parse_sequence_arg(keywords)
        self.api_kwargs = _copy_optional_json(api_kwargs)

    def __init__(
        out self,
        sticker: String,
        emoji_list: List[String],
        format: String,
        mask_position: Optional[MaskPosition] = None,
        keywords: Optional[List[String]] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises:
        self.sticker = parse_file_input(sticker, attach=True, local_mode=True)
        self.emoji_list = parse_sequence_arg(emoji_list)
        self.format = format.copy()
        self.mask_position = mask_position.copy()
        self.keywords = parse_sequence_arg(keywords)
        self.api_kwargs = _copy_optional_json(api_kwargs)

    def __init__(
        out self,
        sticker: Path,
        emoji_list: List[String],
        format: String,
        mask_position: Optional[MaskPosition] = None,
        keywords: Optional[List[String]] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises:
        self.sticker = parse_file_input(sticker, attach=True, local_mode=True)
        self.emoji_list = parse_sequence_arg(emoji_list)
        self.format = format.copy()
        self.mask_position = mask_position.copy()
        self.keywords = parse_sequence_arg(keywords)
        self.api_kwargs = _copy_optional_json(api_kwargs)

    def __init__(
        out self,
        sticker: InputFile,
        emoji_list: List[String],
        format: String,
        mask_position: Optional[MaskPosition] = None,
        keywords: Optional[List[String]] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.sticker = parse_file_input(sticker, attach=True, local_mode=True)
        self.emoji_list = parse_sequence_arg(emoji_list)
        self.format = format.copy()
        self.mask_position = mask_position.copy()
        self.keywords = parse_sequence_arg(keywords)
        self.api_kwargs = _copy_optional_json(api_kwargs)

    def __init__(
        out self,
        sticker: List[UInt8],
        emoji_list: List[String],
        format: String,
        mask_position: Optional[MaskPosition] = None,
        keywords: Optional[List[String]] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ):
        self.sticker = parse_file_input(sticker, attach=True, local_mode=True)
        self.emoji_list = parse_sequence_arg(emoji_list)
        self.format = format.copy()
        self.mask_position = mask_position.copy()
        self.keywords = parse_sequence_arg(keywords)
        self.api_kwargs = _copy_optional_json(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.sticker = existing.sticker.copy()
        self.emoji_list = List[String](copy=existing.emoji_list)
        self.format = existing.format.copy()
        self.mask_position = existing.mask_position.copy()
        self.keywords = List[String](copy=existing.keywords)
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.sticker.kind == ParsedFileInput.FILE_ID:
            result.set_string(result.root, "sticker", self.sticker.file_id.value())
        elif self.sticker.kind == ParsedFileInput.UPLOAD:
            var upload = self.sticker.input_file.value().copy()
            if upload.attach_uri is None:
                result.set_null(result.root, "sticker")
            else:
                result.set_string(result.root, "sticker", upload.attach_uri.value())
        elif self.sticker.kind == ParsedFileInput.PATH:
            raise Error("A non-local Path is not JSON-serializable as an InputSticker")
        else:
            raise Error("InputSticker has an unknown file-input variant")

        _append_strings(result, "emoji_list", self.emoji_list)
        result.set_string(result.root, "format", self.format)
        if self.mask_position is not None:
            var mask_document = self.mask_position.value().to_dict(recursive=recursive)
            var mask_index = result.copy_subtree_from(mask_document, mask_document.root)
            result.object_set(result.root, "mask_position", mask_index)
        _append_strings(result, "keywords", self.keywords)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())
