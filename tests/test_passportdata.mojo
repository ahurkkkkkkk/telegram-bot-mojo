from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import IdDocumentData, PersonalDetails, ResidentialAddress
from telegram._utils.json import parse_json


def main() raises:
    var person = PersonalDetails(
        "Ada",
        "Lovelace",
        "10.12.1815",
        "female",
        "GB",
        "GB",
        Optional[String]("Augusta"),
        Optional[String]("Byron"),
        Optional[String]("King"),
        Optional[String]("Augusta"),
    )
    var person_round_trip = PersonalDetails.de_json(parse_json(person.to_json()))
    assert_equal(person_round_trip.first_name, "Ada")
    assert_equal(person_round_trip.middle_name.value(), "King")
    assert_equal(person_round_trip.last_name_native.value(), "Byron")

    var minimal_person = PersonalDetails.de_json(
        parse_json(
            '{"first_name":"Ada","last_name":"Lovelace","birth_date":"10.12.1815",'
            '"gender":"female","country_code":"GB","residence_country_code":"GB",'
            '"future_field":"preserved"}'
        )
    )
    assert_equal(minimal_person.middle_name is None, True)
    assert_equal(
        minimal_person.api_kwargs.object_get(minimal_person.api_kwargs.root, "future_field") != -1,
        True,
    )
    var minimal_person_round_trip = PersonalDetails.de_json(
        parse_json(minimal_person.to_json())
    )
    assert_equal(
        minimal_person_round_trip.api_kwargs.object_get(
            minimal_person_round_trip.api_kwargs.root, "future_field"
        ) != -1,
        True,
    )

    var address = ResidentialAddress("1 Main St", "Unit 2", "London", "England", "GB", "SW1")
    var address_round_trip = ResidentialAddress.de_json(parse_json(address.to_json()))
    assert_equal(address_round_trip.city, "London")
    assert_equal(address_round_trip.post_code, "SW1")

    var document = IdDocumentData("ABC123", "01.01.2030")
    var document_round_trip = IdDocumentData.de_json(parse_json(document.to_json()))
    assert_equal(document_round_trip.document_no, "ABC123")
    assert_equal(document_round_trip.expiry_date, "01.01.2030")
    with assert_raises():
        _ = PersonalDetails.de_json(parse_json('{"first_name":"missing"}'))

