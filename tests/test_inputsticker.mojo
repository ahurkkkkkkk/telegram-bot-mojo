from std.collections import List
from std.collections.optional import Optional
from std.pathlib import Path
from std.testing import assert_equal, assert_raises

from telegram import InputFile, InputSticker, MaskPosition
from telegram._utils.files import ParsedFileInput
from telegram._utils.json import JSON_ARRAY, JSON_NULL, JSON_OBJECT, JSON_STRING, parse_json
from telegram.request._requestparameter import RequestParameter


def _strings(first: String, second: Optional[String] = None) -> List[String]:
    var result = List[String]()
    result.append(first.copy())
    if second is not None:
        result.append(second.value().copy())
    return result^


def main() raises:
    var emojis = _strings("😀", "🌟")
    var keywords = _strings("star", "sparkle")
    var mask = MaskPosition(MaskPosition.EYES, 0.25, -0.5, 1.5)
    var sticker = InputSticker(
        "telegram-file-id",
        emojis,
        "static",
        mask_position=Optional[MaskPosition](mask.copy()),
        keywords=Optional[List[String]](keywords.copy()),
        api_kwargs=Optional(parse_json("{\"future_flag\":true}")),
    )
    emojis.append("not retained")
    keywords.append("not retained")
    assert_equal(sticker.sticker.file_id.value(), "telegram-file-id")
    assert_equal(len(sticker.emoji_list), 2)
    assert_equal(len(sticker.keywords), 2)
    assert_equal(sticker.format, "static")

    var json = sticker.to_dict()
    assert_equal(json.nodes[json.root].kind, JSON_OBJECT)
    var emoji_index = json.object_get(json.root, "emoji_list")
    assert_equal(json.nodes[emoji_index].kind, JSON_ARRAY)
    assert_equal(json.string_value(json.array_get(emoji_index, 0)), "😀")
    var mask_index = json.object_get(json.root, "mask_position")
    assert_equal(json.string_value(json.object_get(mask_index, "point")), MaskPosition.EYES)
    assert_equal(json.boolean_value(json.object_get(json.root, "future_flag")), True)
    var request_value = RequestParameter.from_input("sticker", sticker).json_value().value()
    var request_json = parse_json(request_value)
    assert_equal(
        request_json.string_value(request_json.object_get(request_json.root, "sticker")),
        "telegram-file-id",
    )

    var no_options = InputSticker("file-id", List[String](), "video")
    var no_options_json = no_options.to_dict()
    assert_equal(no_options_json.object_get(no_options_json.root, "emoji_list"), -1)
    assert_equal(no_options_json.object_get(no_options_json.root, "keywords"), -1)
    assert_equal(no_options_json.object_get(no_options_json.root, "mask_position"), -1)
    assert_equal(len(no_options.keywords), 0)

    var local_path = InputSticker(
        Path("tests/test_inputfile.mojo"), _strings("📎"), "static"
    )
    assert_equal(local_path.sticker.kind, ParsedFileInput.FILE_ID)
    assert_equal(local_path.sticker.file_id.value().startswith("file:///"), True)

    var bytes = List[UInt8]()
    bytes.append(UInt8(0x52))
    bytes.append(UInt8(0x49))
    var uploaded = InputSticker(bytes, _strings("🎨"), "static")
    assert_equal(uploaded.sticker.kind, ParsedFileInput.UPLOAD)
    assert_equal(uploaded.sticker.input_file.value().attach_uri is not None, True)
    var upload_parameter = RequestParameter.from_input("sticker", uploaded)
    assert_equal(len(upload_parameter.input_files), 1)
    var upload_value = parse_json(upload_parameter.json_value().value())
    var upload_uri_index = upload_value.object_get(upload_value.root, "sticker")
    assert_equal(upload_value.nodes[upload_uri_index].kind, JSON_STRING)
    assert_equal(upload_value.string_value(upload_uri_index).startswith("attach://attached"), True)

    var plain_file = InputFile("already prepared")
    var untagged_upload = InputSticker(plain_file, _strings("🎨"), "static")
    var untagged_parameter = RequestParameter.from_input("sticker", untagged_upload)
    assert_equal(len(untagged_parameter.input_files), 1)
    var untagged_document = untagged_upload.to_dict()
    assert_equal(
        untagged_document.nodes[
            untagged_document.object_get(untagged_document.root, "sticker")
        ].kind,
        JSON_NULL,
    )

    var missing_path = InputSticker(Path("missing/sticker.webp"), List[String](), "static")
    assert_equal(missing_path.sticker.kind, ParsedFileInput.PATH)
    with assert_raises():
        _ = missing_path.to_dict()

    with assert_raises():
        _ = RequestParameter.from_input("sticker", missing_path)
