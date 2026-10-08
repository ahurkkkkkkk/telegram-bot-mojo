#!/usr/bin/env mojo
#
# Native file upload value corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""In-memory Telegram file upload data and multipart metadata."""

from std.collections import List
from std.collections.optional import Optional
from std.random import random_si64


comptime DEFAULT_MIME_TYPE = "application/octet-stream"


struct UploadField(Copyable):
    """The filename, byte content, and MIME type required for one multipart part."""

    var filename: String
    var content: List[UInt8]
    var mimetype: String

    def __init__(out self, filename: String, content: List[UInt8], mimetype: String):
        self.filename = filename.copy()
        self.content = List[UInt8](copy=content)
        self.mimetype = mimetype.copy()

    def __copyinit__(out self, existing: Self):
        self.filename = existing.filename.copy()
        self.content = List[UInt8](copy=existing.content)
        self.mimetype = existing.mimetype.copy()


def _ends_with_ascii_case_insensitive(value: String, suffix: String) -> Bool:
    var value_bytes = value.as_bytes()
    var suffix_bytes = suffix.as_bytes()
    if len(suffix_bytes) > len(value_bytes):
        return False
    var offset = len(value_bytes) - len(suffix_bytes)
    for index in range(len(suffix_bytes)):
        var left = value_bytes[offset + index]
        var right = suffix_bytes[index]
        if left >= 65 and left <= 90:
            left = left + 32
        if right >= 65 and right <= 90:
            right = right + 32
        if left != right:
            return False
    return True


def _guess_mime_type(filename: String) -> String:
    if _ends_with_ascii_case_insensitive(filename, ".jpg") or _ends_with_ascii_case_insensitive(
        filename, ".jpeg"
    ):
        return "image/jpeg"
    if _ends_with_ascii_case_insensitive(filename, ".png"):
        return "image/png"
    if _ends_with_ascii_case_insensitive(filename, ".gif"):
        return "image/gif"
    if _ends_with_ascii_case_insensitive(filename, ".webp"):
        return "image/webp"
    if _ends_with_ascii_case_insensitive(filename, ".pdf"):
        return "application/pdf"
    if _ends_with_ascii_case_insensitive(filename, ".txt"):
        return "text/plain"
    if _ends_with_ascii_case_insensitive(filename, ".json"):
        return "application/json"
    if _ends_with_ascii_case_insensitive(filename, ".mp3"):
        return "audio/mpeg"
    if _ends_with_ascii_case_insensitive(filename, ".ogg"):
        return "audio/ogg"
    if _ends_with_ascii_case_insensitive(filename, ".mp4"):
        return "video/mp4"
    if _ends_with_ascii_case_insensitive(filename, ".webm"):
        return "video/webm"
    if _ends_with_ascii_case_insensitive(filename, ".zip"):
        return "application/zip"
    return DEFAULT_MIME_TYPE


def _new_attach_name() -> String:
    # A pair of independent 31-bit draws makes collisions negligible for the
    # lifetime of a process while keeping the attach:// value text-only.
    return String(
        "attached", String(random_si64(0, 2147483647)), String(random_si64(0, 2147483647))
    )


struct _PreparedInputFile(Copyable):
    var content: List[UInt8]
    var attach_name: Optional[String]
    var attach_uri: Optional[String]
    var filename: String
    var mimetype: String

    def __init__(
        out self,
        content: List[UInt8],
        filename: Optional[String],
        attach: Bool,
    ):
        self.content = List[UInt8](copy=content)
        self.attach_name = None
        self.attach_uri = None
        self.filename = String("application.octet-stream")
        self.mimetype = DEFAULT_MIME_TYPE
        if filename is not None and filename.value().byte_length() > 0:
            self.filename = filename.value().copy()
            self.mimetype = _guess_mime_type(self.filename)
        if attach:
            var generated = _new_attach_name()
            self.attach_name = Optional[String](generated.copy())
            self.attach_uri = Optional[String](String("attach://", generated))


def _prepare_input_file(
    content: List[UInt8], filename: Optional[String], attach: Bool
) -> _PreparedInputFile:
    return _PreparedInputFile(content, filename, attach)


struct InputFile(Copyable):
    """An in-memory upload file accepted by the Telegram request layer.

    Mojo stores the content as UTF-8 bytes or caller-supplied bytes. Streaming
    file handles are represented separately by future transport work.
    """

    var input_file_content: List[UInt8]
    var attach_name: Optional[String]
    var attach_uri: Optional[String]
    var filename: String
    var mimetype: String

    def __init__(
        out self,
        content: String,
        filename: Optional[String] = None,
        attach: Bool = False,
    ):
        var bytes = List[UInt8]()
        for byte in content.as_bytes():
            bytes.append(byte)
        var prepared = _prepare_input_file(bytes, filename, attach)
        self.input_file_content = List[UInt8](copy=prepared.content)
        self.attach_name = prepared.attach_name
        self.attach_uri = prepared.attach_uri
        self.filename = prepared.filename.copy()
        self.mimetype = prepared.mimetype.copy()

    def __init__(
        out self,
        content: List[UInt8],
        filename: Optional[String] = None,
        attach: Bool = False,
    ):
        var prepared = _prepare_input_file(content, filename, attach)
        self.input_file_content = List[UInt8](copy=prepared.content)
        self.attach_name = prepared.attach_name
        self.attach_uri = prepared.attach_uri
        self.filename = prepared.filename.copy()
        self.mimetype = prepared.mimetype.copy()

    def __copyinit__(out self, existing: Self):
        self.input_file_content = List[UInt8](copy=existing.input_file_content)
        self.attach_name = existing.attach_name
        self.attach_uri = existing.attach_uri
        self.filename = existing.filename.copy()
        self.mimetype = existing.mimetype.copy()

    def field_tuple(self) -> UploadField:
        return UploadField(self.filename, self.input_file_content, self.mimetype)
