#!/usr/bin/env mojo
#
# Native file helpers translated from python-telegram-bot v22.8 _utils/files.py.
# LGPL-3.0-or-later; see LICENSE.

"""Native file-input classification and upload preparation."""

from std.collections import List
from std.collections.optional import Optional
from std.pathlib import Path, cwd

from telegram._files.inputfile import InputFile


struct ParsedFileInput(Copyable):
    """Tagged native equivalent of the supported ``str | InputFile | Path`` result.

    The source API can also pass arbitrary Python file objects and Telegram
    model instances through its dynamic return type. Mojo callers use an
    explicit tag for text IDs/URIs, uploads, and untouched Path values.
    """

    comptime FILE_ID = UInt8(0)
    comptime UPLOAD = UInt8(1)
    comptime PATH = UInt8(2)

    var kind: UInt8
    var file_id: Optional[String]
    var input_file: Optional[InputFile]
    var path: Optional[Path]

    def __init__(out self, file_id: String):
        self.kind = Self.FILE_ID
        self.file_id = Optional[String](file_id.copy())
        self.input_file = None
        self.path = None

    def __init__(out self, input_file: InputFile):
        self.kind = Self.UPLOAD
        self.file_id = None
        self.input_file = Optional[InputFile](input_file.copy())
        self.path = None

    def __init__(out self, path: Path):
        self.kind = Self.PATH
        self.file_id = None
        self.input_file = None
        self.path = Optional[Path](Path(path.path))

    def __copyinit__(out self, existing: Self):
        self.kind = existing.kind
        if existing.file_id is None:
            self.file_id = None
        else:
            self.file_id = Optional[String](existing.file_id.value().copy())
        if existing.input_file is None:
            self.input_file = None
        else:
            self.input_file = Optional[InputFile](existing.input_file.value().copy())
        if existing.path is None:
            self.path = None
        else:
            self.path = Optional[Path](Path(existing.path.value().path))


def load_file(obj: String) -> Tuple[Optional[String], String]:
    """Strings are not file handles and are returned unchanged."""
    return (None, obj.copy())


def load_file(obj: Path) -> Tuple[Optional[String], Path]:
    """A Path is not a file handle; preserve it unchanged."""
    return (None, Path(obj.path))


def load_file(obj: InputFile) -> Tuple[Optional[String], InputFile]:
    """An InputFile is not a file handle; preserve a native copy."""
    return (None, obj.copy())


def load_file(obj: List[UInt8]) -> Tuple[Optional[String], List[UInt8]]:
    """A byte list is preserved as the native representation of Python bytes."""
    return (None, List[UInt8](copy=obj))


def load_file(obj: Optional[String]) -> Tuple[Optional[String], Optional[String]]:
    """An unset input remains unset; a present string remains unchanged."""
    if obj is None:
        return (None, None)
    return (None, Optional[String](obj.value().copy()))


def guess_file_name(obj: String) -> Optional[String]:
    """Strings have no file-handle ``name`` attribute."""
    return None


def guess_file_name(obj: Path) -> Optional[String]:
    """Return the final path component, matching ``Path(obj.name).name``."""
    return Optional[String](obj.name())


def guess_file_name(obj: InputFile) -> Optional[String]:
    """InputFile metadata is stored as ``filename``, not a stream ``name``."""
    return None


def guess_file_name(obj: List[UInt8]) -> Optional[String]:
    """Byte content has no file name unless one is supplied separately."""
    return None


def guess_file_name(obj: Optional[String]) -> Optional[String]:
    """Unset values and strings do not carry a file-handle name."""
    return None


def is_local_file(obj: String) -> Bool:
    """Check whether a string names an existing regular file."""
    return Path(obj).is_file()


def is_local_file(obj: Path) -> Bool:
    """Check whether a Path names an existing regular file."""
    return obj.is_file()


def is_local_file(obj: Optional[String]) -> Bool:
    """Unset paths are not local files."""
    if obj is None:
        return False
    return Path(obj.value()).is_file()


def _push_path_component(mut components: List[String], component: String):
    if component.byte_length() == 0 or component == ".":
        return
    if component == "..":
        if len(components) > 0:
            _ = components.pop()
        return
    components.append(component.copy())


def _normalize_absolute_path(path: String) -> String:
    """Lexically normalize an absolute POSIX path without resolving symlinks."""
    var components = List[String]()
    var current = String()
    for character in path.codepoint_slices():
        if character == "/":
            _push_path_component(components, current)
            current = String()
        else:
            current += character
    _push_path_component(components, current)

    var result = String("/")
    for index in range(len(components)):
        result += components[index]
        if index + 1 < len(components):
            result += "/"
    return result


def _absolute_path(path: String) raises -> String:
    var combined = path.copy()
    if not path.startswith("/"):
        combined = String(cwd().path, "/", path)
    return _normalize_absolute_path(combined)


def _hex_digit(value: Int) -> String:
    if value == 0:
        return "0"
    if value == 1:
        return "1"
    if value == 2:
        return "2"
    if value == 3:
        return "3"
    if value == 4:
        return "4"
    if value == 5:
        return "5"
    if value == 6:
        return "6"
    if value == 7:
        return "7"
    if value == 8:
        return "8"
    if value == 9:
        return "9"
    if value == 10:
        return "A"
    if value == 11:
        return "B"
    if value == 12:
        return "C"
    if value == 13:
        return "D"
    if value == 14:
        return "E"
    return "F"


def _path_as_file_uri(path: String) raises -> String:
    """Build a percent-encoded absolute ``file:///`` URI for a local path."""
    var absolute = _absolute_path(path)
    var encoded = String()
    for byte in absolute.as_bytes():
        var value = Int(byte)
        var is_unreserved = (
            (value >= 65 and value <= 90) or
            (value >= 97 and value <= 122) or
            (value >= 48 and value <= 57) or
            value == 45 or value == 95 or value == 46 or value == 126
        )
        if is_unreserved or value == 47:
            encoded += chr(value)
        else:
            encoded += "%"
            encoded += _hex_digit(value // 16)
            encoded += _hex_digit(value % 16)
    return String("file://", encoded)


def _parse_path_string(
    path: String,
    filename: Optional[String],
    attach: Bool,
    local_mode: Bool,
    preserve_path: Bool,
) raises -> ParsedFileInput:
    var native_path = Path(path)
    if not native_path.is_file():
        if preserve_path:
            return ParsedFileInput(native_path)
        return ParsedFileInput(path)

    if local_mode:
        return ParsedFileInput(_path_as_file_uri(path))

    var resolved_filename = filename
    if resolved_filename is None:
        resolved_filename = Optional[String](native_path.name())
    var upload = InputFile(native_path.read_bytes(), filename=resolved_filename, attach=attach)
    return ParsedFileInput(upload)


def parse_file_input(
    file_input: String,
    filename: Optional[String] = None,
    attach: Bool = False,
    local_mode: Bool = False,
) raises -> ParsedFileInput:
    """Normalize a file ID, local path, or local-mode file URI."""
    if file_input.startswith("file://"):
        if not local_mode:
            raise Error("Specified file input is a file URI, but local mode is not enabled.")
        return ParsedFileInput(file_input)
    return _parse_path_string(file_input, filename, attach, local_mode, False)


def parse_file_input(
    file_input: Path,
    filename: Optional[String] = None,
    attach: Bool = False,
    local_mode: Bool = False,
) raises -> ParsedFileInput:
    """Normalize a Path using the same filesystem behavior as the string overload."""
    return _parse_path_string(file_input.path, filename, attach, local_mode, True)


def parse_file_input(
    file_input: InputFile,
    filename: Optional[String] = None,
    attach: Bool = False,
    local_mode: Bool = False,
) -> ParsedFileInput:
    """Pass through an already-prepared native upload unchanged."""
    return ParsedFileInput(file_input)


def parse_file_input(
    file_input: List[UInt8],
    filename: Optional[String] = None,
    attach: Bool = False,
    local_mode: Bool = False,
) -> ParsedFileInput:
    """Wrap byte content as an InputFile, optionally with multipart attachment."""
    return ParsedFileInput(InputFile(file_input, filename=filename, attach=attach))
