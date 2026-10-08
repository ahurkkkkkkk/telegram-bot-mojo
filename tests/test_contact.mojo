from std.testing import assert_equal, assert_raises
from std.collections.optional import Optional

from telegram import Contact
from telegram._utils.json import parse_json


def main() raises:
    var contact = Contact(
        "15551234567",
        "Ada",
        Optional[String]("Lovelace"),
        Optional[Int](42),
        Optional[String]("BEGIN:VCARD"),
    )
    assert_equal(
        contact.to_json(),
        "{\"phone_number\": \"15551234567\", \"first_name\": \"Ada\", \"last_name\": \"Lovelace\", \"user_id\": 42, \"vcard\": \"BEGIN:VCARD\"}",
    )

    var decoded = Contact.de_json(
        parse_json(
            "{\"phone_number\":\"15551234567\",\"first_name\":\"Ada\",\"last_name\":\"Lovelace\",\"user_id\":42,\"vcard\":\"BEGIN:VCARD\",\"future\":{\"x\":true}}"
        )
    )
    assert_equal(decoded.phone_number, "15551234567")
    assert_equal(decoded.first_name, "Ada")
    assert_equal(decoded.last_name.value(), "Lovelace")
    assert_equal(decoded.user_id.value(), 42)
    assert_equal(decoded.vcard.value(), "BEGIN:VCARD")
    assert_equal(
        decoded.to_json(),
        "{\"phone_number\": \"15551234567\", \"first_name\": \"Ada\", \"last_name\": \"Lovelace\", \"user_id\": 42, \"vcard\": \"BEGIN:VCARD\", \"future\": {\"x\": true}}",
    )
    assert_equal(decoded == Contact("15551234567", "Different Name"), True)
    assert_equal(hash(decoded), hash(Contact("15551234567", "Different Name")))

    var null_fields = Contact.de_json(
        parse_json("{\"phone_number\":\"1\",\"first_name\":\"A\",\"last_name\":null,\"user_id\":null,\"vcard\":null}")
    )
    assert_equal(null_fields.last_name is None, True)
    assert_equal(null_fields.user_id is None, True)
    assert_equal(null_fields.vcard is None, True)
    assert_equal(null_fields.to_json(), "{\"phone_number\": \"1\", \"first_name\": \"A\"}")

    var list = Contact.de_list(parse_json("[{\"phone_number\":\"1\",\"first_name\":\"A\"}]"), 0)
    assert_equal(len(list), 1)
    assert_equal(list[0].first_name, "A")

    with assert_raises():
        _ = Contact.de_json(parse_json("{\"first_name\":\"A\"}"))
    with assert_raises():
        _ = Contact.de_json(parse_json("[]"))
