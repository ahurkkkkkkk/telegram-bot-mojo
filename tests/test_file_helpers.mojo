from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises
from std.pathlib import Path

from telegram import InputFile
from telegram._utils.files import (
    ParsedFileInput,
    _path_as_file_uri,
    guess_file_name,
    is_local_file,
    load_file,
    parse_file_input,
)
from telegram.request._requestparameter import RequestParameter


def main() raises:
    var file_path = Path("tests/test_inputfile.mojo")
    assert_equal(is_local_file(file_path), True)
    assert_equal(is_local_file("tests/test_inputfile.mojo"), True)
    assert_equal(is_local_file("tests/no_such_file.mojo"), False)
    var no_path: Optional[String] = None
    assert_equal(is_local_file(no_path), False)

    assert_equal(guess_file_name(file_path).value(), "test_inputfile.mojo")
    assert_equal(guess_file_name("telegram-file-id") is None, True)
    assert_equal(guess_file_name(InputFile("bytes")) is None, True)
    assert_equal(load_file("telegram-file-id")[0] is None, True)
    assert_equal(load_file("telegram-file-id")[1], "telegram-file-id")
    assert_equal(load_file(file_path)[1].path, file_path.path)

    var file_id = parse_file_input("telegram-file-id")
    assert_equal(file_id.kind, ParsedFileInput.FILE_ID)
    assert_equal(file_id.file_id.value(), "telegram-file-id")
    var unknown_path_as_string = parse_file_input("missing/path.bin")
    assert_equal(unknown_path_as_string.file_id.value(), "missing/path.bin")
    var unknown_path = parse_file_input(Path("missing/path.bin"))
    assert_equal(unknown_path.kind, ParsedFileInput.PATH)
    assert_equal(unknown_path.path.value().path, "missing/path.bin")
    with assert_raises():
        _ = RequestParameter.from_input("file", unknown_path)

    var uri = parse_file_input("file:///tmp/already-uploaded", local_mode=True)
    assert_equal(uri.file_id.value(), "file:///tmp/already-uploaded")
    with assert_raises():
        _ = parse_file_input("file:///tmp/rejected", local_mode=False)

    var upload = parse_file_input("tests/test_inputfile.mojo", attach=True)
    assert_equal(upload.kind, ParsedFileInput.UPLOAD)
    assert_equal(upload.input_file.value().filename, "test_inputfile.mojo")
    assert_equal(upload.input_file.value().attach_uri is not None, True)
    assert_equal(upload.input_file.value().input_file_content[0], UInt8(102))
    var upload_parameter = RequestParameter.from_input("document", upload)
    assert_equal(upload_parameter.input_files[0].attach_uri is not None, True)
    assert_equal(upload_parameter.json_value().value().startswith("attach://attached"), True)

    var local_uri = parse_file_input("tests/test_inputfile.mojo", local_mode=True)
    assert_equal(local_uri.kind, ParsedFileInput.FILE_ID)
    assert_equal(local_uri.file_id.value().startswith("file:///"), True)
    var encoded_uri = _path_as_file_uri("relative/space name#tag.txt")
    assert_equal(encoded_uri.endswith("space%20name%23tag.txt"), True)

    var bytes = List[UInt8]()
    bytes.append(UInt8(1))
    bytes.append(UInt8(255))
    var bytes_upload = parse_file_input(bytes, filename=Optional[String]("sticker.webp"), attach=True)
    assert_equal(bytes_upload.input_file.value().mimetype, "image/webp")
    assert_equal(bytes_upload.input_file.value().input_file_content[1], UInt8(255))
    assert_equal(bytes_upload.input_file.value().attach_uri is not None, True)
    assert_equal(
        RequestParameter.from_input("sticker", bytes_upload).json_value().value().startswith(
            "attach://attached"
        ),
        True,
    )

    var existing_upload = InputFile("already prepared")
    assert_equal(parse_file_input(existing_upload).input_file.value().filename, existing_upload.filename)
