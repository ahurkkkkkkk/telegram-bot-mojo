from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import Audio, LivePhoto, Location, PhotoSize, PollMedia, Video
from telegram._utils.datetime import TimeDelta
from telegram._utils.json import parse_json


def main() raises:
    var photos = List[PhotoSize]()
    photos.append(PhotoSize("small", "small-unique", 10, 12))
    photos.append(PhotoSize("large", "large-unique", 40, 48))
    var media = PollMedia(
        photo=photos,
        audio=Optional[Audio](Audio("audio-id", "audio-unique", TimeDelta(1), title=Optional[String]("title"))),
        location=Optional[Location](Location(-3.5, 1.25)),
        live_photo=Optional[LivePhoto](LivePhoto("live-id", "live-unique", 8, 9, TimeDelta(2))),
        video=Optional[Video](Video("video-id", "video-unique", 20, 30, TimeDelta(2))),
    )
    var encoded = media.to_json()
    var decoded = PollMedia.de_json(parse_json(encoded))
    assert_equal(decoded == media, True)
    assert_equal(decoded.photo[1].file_id, "large")
    assert_equal(decoded.audio.value().title, "title")
    assert_equal(decoded.location.value().longitude, -3.5)
    assert_equal(decoded.live_photo.value().file_id, "live-id")
    assert_equal(decoded.video.value().file_id, "video-id")
    assert_equal(len(PollMedia.de_list(parse_json("[" + encoded + "]"), 0)), 1)

    var future = PollMedia.de_json(parse_json('{"future_media":{"kind":"later"}}'))
    assert_equal(future.to_json(), '{"future_media": {"kind": "later"}}')
    assert_equal(PollMedia.de_json(parse_json("{}")) == PollMedia(), True)
