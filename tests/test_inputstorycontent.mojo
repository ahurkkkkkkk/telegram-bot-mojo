from std.collections import List
from std.collections.optional import Optional
from std.pathlib import Path
from std.testing import assert_equal, assert_raises

from telegram import InputFile, InputStoryContent
from telegram._utils.datetime import TimeDelta
from telegram._utils.files import ParsedFileInput, parse_file_input
from telegram._utils.json import JSON_BOOL, JSON_NULL, JSON_NUMBER, JSON_STRING, parse_json
from telegram.request._requestparameter import RequestParameter


def main() raises:
    var photo = InputStoryContent.photo_content("telegram-photo-id")
    assert_equal(photo.type, InputStoryContent.PHOTO)
    assert_equal(photo.photo.value().kind, ParsedFileInput.FILE_ID)
    assert_equal(photo.to_json(), "{\"type\": \"photo\", \"photo\": \"telegram-photo-id\"}")

    var local_photo = InputStoryContent.photo_content(Path("tests/test_inputfile.mojo"))
    assert_equal(local_photo.photo.value().file_id.value().startswith("file:///"), True)

    var raw = List[UInt8]()
    raw.append(UInt8(0x41))
    raw.append(UInt8(0x42))
    var video = InputStoryContent.video_content(
        raw,
        duration=Optional[Float64](12.5),
        cover_frame_timestamp=Optional[Float64](1.25),
        is_animation=Optional[Bool](False),
    )
    assert_equal(video.type, InputStoryContent.VIDEO)
    assert_equal(video.video.value().kind, ParsedFileInput.UPLOAD)
    var video_json = video.to_dict()
    var duration_index = video_json.object_get(video_json.root, "duration")
    var cover_index = video_json.object_get(video_json.root, "cover_frame_timestamp")
    var animation_index = video_json.object_get(video_json.root, "is_animation")
    assert_equal(video_json.nodes[duration_index].kind, JSON_NUMBER)
    assert_equal(video_json.number_text(duration_index), "12.5")
    assert_equal(video_json.number_text(cover_index), "1.25")
    assert_equal(video_json.nodes[animation_index].kind, JSON_BOOL)
    assert_equal(video_json.boolean_value(animation_index), False)
    assert_equal(video_json.object_get(video_json.root, "photo"), -1)

    var request_parameter = RequestParameter.from_input("story", video)
    assert_equal(len(request_parameter.input_files), 1)
    var request_json = parse_json(request_parameter.json_value().value())
    var video_index = request_json.object_get(request_json.root, "video")
    assert_equal(request_json.nodes[video_index].kind, JSON_STRING)
    assert_equal(request_json.string_value(video_index).startswith("attach://attached"), True)

    var prepared = InputStoryContent.photo_content(InputFile("already prepared"))
    assert_equal(len(RequestParameter.from_input("story", prepared).input_files), 1)
    var prepared_json = prepared.to_dict()
    var prepared_photo = prepared_json.object_get(prepared_json.root, "photo")
    assert_equal(prepared_json.nodes[prepared_photo].kind, JSON_NULL)

    var pathless = InputStoryContent.video_with_native_durations(
        parse_file_input(Path("missing/video.mp4")),
        duration=Optional[TimeDelta](TimeDelta(3)),
    )
    assert_equal(pathless.video.value().kind, ParsedFileInput.PATH)
    with assert_raises():
        _ = pathless.to_dict()
