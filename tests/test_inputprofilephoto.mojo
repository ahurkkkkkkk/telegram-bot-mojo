from std.collections import List
from std.collections.optional import Optional
from std.pathlib import Path
from std.testing import assert_equal, assert_raises

from telegram import InputFile, InputProfilePhoto
from telegram._utils.files import ParsedFileInput
from telegram._utils.json import JSON_NULL, JSON_NUMBER, JSON_STRING, parse_json
from telegram.request._requestparameter import RequestParameter


def main() raises:
    var id_photo = InputProfilePhoto("static")
    assert_equal(id_photo.type, InputProfilePhoto.STATIC)
    assert_equal(id_photo.to_json(), "{\"type\": \"static\"}")

    var static_photo = InputProfilePhoto.static("telegram-photo-id")
    assert_equal(static_photo.photo.value().kind, ParsedFileInput.FILE_ID)
    var static_json = static_photo.to_dict()
    assert_equal(
        static_json.string_value(static_json.object_get(static_json.root, "photo")),
        "telegram-photo-id",
    )
    assert_equal(static_json.object_get(static_json.root, "animation"), -1)

    var local_photo = InputProfilePhoto.static(Path("tests/test_inputfile.mojo"))
    assert_equal(local_photo.photo.value().file_id.value().startswith("file:///"), True)

    var photo_bytes = List[UInt8]()
    photo_bytes.append(UInt8(0xFF))
    var animated = InputProfilePhoto.animated(
        photo_bytes, main_frame_timestamp=Optional[Float64](0.25)
    )
    assert_equal(animated.type, InputProfilePhoto.ANIMATED)
    assert_equal(animated.animation.value().kind, ParsedFileInput.UPLOAD)
    assert_equal(animated.animation.value().input_file.value().attach_uri is not None, True)
    var animated_json = animated.to_dict()
    var timestamp_index = animated_json.object_get(animated_json.root, "main_frame_timestamp")
    assert_equal(animated_json.nodes[timestamp_index].kind, JSON_NUMBER)
    assert_equal(animated_json.number_text(timestamp_index), "0.25")
    assert_equal(animated_json.object_get(animated_json.root, "photo"), -1)

    var parameter = RequestParameter.from_input("profile_photo", animated)
    assert_equal(len(parameter.input_files), 1)
    var parameter_json = parse_json(parameter.json_value().value())
    var animation_index = parameter_json.object_get(parameter_json.root, "animation")
    assert_equal(parameter_json.nodes[animation_index].kind, JSON_STRING)
    assert_equal(parameter_json.string_value(animation_index).startswith("attach://attached"), True)

    var untagged = InputProfilePhoto.static(InputFile("raw photo"))
    var untagged_parameter = RequestParameter.from_input("profile_photo", untagged)
    assert_equal(len(untagged_parameter.input_files), 1)
    var untagged_json = untagged.to_dict()
    var untagged_photo_index = untagged_json.object_get(untagged_json.root, "photo")
    assert_equal(
        untagged_json.nodes[untagged_photo_index].kind,
        JSON_NULL,
    )

    var missing = InputProfilePhoto.static(Path("missing/photo.jpg"))
    assert_equal(missing.photo.value().kind, ParsedFileInput.PATH)
    with assert_raises():
        _ = missing.to_dict()
