from std.collections import List
from std.testing import assert_equal, assert_raises

from telegram import PassportData
from telegram._utils.json import parse_json


def main() raises:
    var element = (
        '{"type":"passport","hash":"element-hash","data":"encrypted-value",'
        '"phone_number":"+15551234567"}'
    )
    var json = String(
        '{"data":[', element,
        '],"credentials":{"data":"encrypted-credentials","hash":"credential-hash",'
        '"secret":"encrypted-secret"},"future_field":42}'
    )
    var passport_data = PassportData.de_json(parse_json(json))
    assert_equal(len(passport_data.data), 1)
    assert_equal(passport_data.data[0].type, "passport")
    assert_equal(passport_data.credentials.hash, "credential-hash")
    assert_equal(
        passport_data.api_kwargs.object_get(passport_data.api_kwargs.root, "future_field") != -1,
        True,
    )

    var round_trip = PassportData.de_json(parse_json(passport_data.to_json()))
    assert_equal(round_trip == passport_data, True)
    assert_equal(hash(round_trip), hash(passport_data))
    assert_equal(len(PassportData.de_list(parse_json("[" + json + "]"), 0)), 1)

    var same_identity_json = String(
        '{"data":[{"type":"passport","hash":"other-element-hash",'
        '"data":"other-value"}],"credentials":{"data":"new-encrypted-data",'
        '"hash":"credential-hash","secret":"other-secret"}}'
    )
    var same_identity = PassportData.de_json(parse_json(same_identity_json))
    assert_equal(same_identity == passport_data, True)
    assert_equal(hash(same_identity), hash(passport_data))

    var empty = PassportData.de_json(
        parse_json(
            '{"credentials":{"data":"d","hash":"h","secret":"s"}}'
        )
    )
    assert_equal(len(empty.data), 0)
    with assert_raises():
        _ = PassportData.de_json(parse_json('{"data":[]}'))

