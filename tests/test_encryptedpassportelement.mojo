from std.testing import assert_equal, assert_raises

from telegram import EncryptedPassportElement
from telegram._utils.json import parse_json


def _file(id: String) -> String:
    return String(
        '{"file_id":"', id,
        '","file_unique_id":"unique-1","file_date":1,"file_size":8}'
    )


def main() raises:
    var json = String(
        '{"type":"passport","hash":"encoded-hash","data":"encrypted-data",'
        '"phone_number":"+15551234567","files":[', _file("front"), '],"front_side":',
        _file("front"), ',"translation":[', _file("translation"),
        '],"future_field":{"retained":true}}'
    )
    var element = EncryptedPassportElement.de_json(parse_json(json))
    assert_equal(element.type, "passport")
    assert_equal(element.hash, "encoded-hash")
    assert_equal(element.data is not None, True)
    assert_equal(element.data.value().string_value(element.data.value().root), "encrypted-data")
    assert_equal(element.phone_number.value(), "+15551234567")
    assert_equal(len(element.files), 1)
    assert_equal(element.files[0].file_id, "front")
    assert_equal(element.front_side.value().file_unique_id, "unique-1")
    assert_equal(len(element.translation), 1)
    assert_equal(
        element.api_kwargs.object_get(element.api_kwargs.root, "future_field") != -1,
        True,
    )

    var round_trip = EncryptedPassportElement.de_json(parse_json(element.to_json()))
    assert_equal(round_trip == element, True)
    assert_equal(hash(round_trip), hash(element))
    assert_equal(len(EncryptedPassportElement.de_list(parse_json("[" + json + "]"), 0)), 1)

    var same_json = String(
        '{"type":"passport","hash":"different-hash","data":"encrypted-data",'
        '"phone_number":"+15551234567","files":[', _file("other"),
        '],"front_side":', _file("another"), ',"translation":[', _file("different"), ']}'
    )
    var same_identity = EncryptedPassportElement.de_json(parse_json(same_json))
    assert_equal(same_identity == element, True)
    assert_equal(hash(same_identity), hash(element))

    var object_data = EncryptedPassportElement.de_json(
        parse_json('{"type":"address","hash":"h","data":{"city":"London"}}')
    )
    var object_data_copy = EncryptedPassportElement.de_json(
        parse_json('{"type":"address","hash":"h","data":{"city":"London"}}')
    )
    assert_equal(object_data == object_data_copy, True)
    assert_equal(hash(object_data), hash(object_data_copy))
    assert_equal(
        object_data.data.value().object_get(object_data.data.value().root, "city") != -1,
        True,
    )

    with assert_raises():
        _ = EncryptedPassportElement.de_json(parse_json('{"type":"passport"}'))
