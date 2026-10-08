from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import InputFile


def main() raises:
    var photo = InputFile("data", filename=Optional[String]("photo.JPG"), attach=True)
    assert_equal(photo.filename, "photo.JPG")
    assert_equal(photo.mimetype, "image/jpeg")
    assert_equal(len(photo.input_file_content), 4)
    assert_equal(photo.input_file_content[0], UInt8(100))
    assert_equal(photo.attach_uri is not None, True)
    assert_equal(photo.attach_uri.value().startswith("attach://attached"), True)
    assert_equal(photo.field_tuple().mimetype, "image/jpeg")

    var second = InputFile("other", attach=True)
    assert_equal(photo.attach_name == second.attach_name, False)

    var raw = List[UInt8]()
    raw.append(UInt8(1))
    raw.append(UInt8(255))
    var upload = InputFile(raw, filename=Optional[String]("archive.zip"))
    assert_equal(upload.mimetype, "application/zip")
    assert_equal(upload.filename, "archive.zip")
    assert_equal(upload.input_file_content[1], UInt8(255))

    var anonymous = InputFile("x")
    assert_equal(anonymous.filename, "application.octet-stream")
    assert_equal(anonymous.mimetype, "application/octet-stream")
    assert_equal(anonymous.attach_uri is None, True)
