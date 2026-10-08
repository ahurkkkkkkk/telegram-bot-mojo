#!/usr/bin/env mojo
#
# Native Passport data models corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Decrypted personal, address, and identity-document fields for Telegram Passport."""

from std.collections import List
from std.collections.optional import Optional

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _passport_data_required_string(data: JsonDocument, key: String) raises -> String:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        raise Error(String("Passport data is missing required field: ", key))
    return data.string_value(index)


def _passport_data_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


def _passport_data_unknown_fields(data: JsonDocument, known: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var recognized = False
        for known_key in known:
            if key == known_key:
                recognized = True
                break
        if not recognized:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct PersonalDetails(Copyable, TelegramJsonObject):
    """Personal details, preserving optional native-script names and future fields."""

    var first_name: String
    var last_name: String
    var middle_name: Optional[String]
    var birth_date: String
    var gender: String
    var country_code: String
    var residence_country_code: String
    var first_name_native: Optional[String]
    var last_name_native: Optional[String]
    var middle_name_native: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        first_name: String,
        last_name: String,
        birth_date: String,
        gender: String,
        country_code: String,
        residence_country_code: String,
        first_name_native: Optional[String] = None,
        last_name_native: Optional[String] = None,
        middle_name: Optional[String] = None,
        middle_name_native: Optional[String] = None,
    ):
        self.first_name = first_name.copy()
        self.last_name = last_name.copy()
        self.middle_name = middle_name.copy()
        self.birth_date = birth_date.copy()
        self.gender = gender.copy()
        self.country_code = country_code.copy()
        self.residence_country_code = residence_country_code.copy()
        self.first_name_native = first_name_native.copy()
        self.last_name_native = last_name_native.copy()
        self.middle_name_native = middle_name_native.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        first_name: String,
        last_name: String,
        birth_date: String,
        gender: String,
        country_code: String,
        residence_country_code: String,
        first_name_native: Optional[String],
        last_name_native: Optional[String],
        middle_name: Optional[String],
        middle_name_native: Optional[String],
        *,
        api_kwargs: JsonDocument,
    ):
        self.first_name = first_name.copy()
        self.last_name = last_name.copy()
        self.middle_name = middle_name.copy()
        self.birth_date = birth_date.copy()
        self.gender = gender.copy()
        self.country_code = country_code.copy()
        self.residence_country_code = residence_country_code.copy()
        self.first_name_native = first_name_native.copy()
        self.last_name_native = last_name_native.copy()
        self.middle_name_native = middle_name_native.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.first_name = existing.first_name.copy()
        self.last_name = existing.last_name.copy()
        self.middle_name = existing.middle_name.copy()
        self.birth_date = existing.birth_date.copy()
        self.gender = existing.gender.copy()
        self.country_code = existing.country_code.copy()
        self.residence_country_code = existing.residence_country_code.copy()
        self.first_name_native = existing.first_name_native.copy()
        self.last_name_native = existing.last_name_native.copy()
        self.middle_name_native = existing.middle_name_native.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "first_name", self.first_name)
        result.set_string(result.root, "last_name", self.last_name)
        if self.middle_name is not None:
            result.set_string(result.root, "middle_name", self.middle_name.value())
        result.set_string(result.root, "birth_date", self.birth_date)
        result.set_string(result.root, "gender", self.gender)
        result.set_string(result.root, "country_code", self.country_code)
        result.set_string(result.root, "residence_country_code", self.residence_country_code)
        if self.first_name_native is not None:
            result.set_string(result.root, "first_name_native", self.first_name_native.value())
        if self.last_name_native is not None:
            result.set_string(result.root, "last_name_native", self.last_name_native.value())
        if self.middle_name_native is not None:
            result.set_string(result.root, "middle_name_native", self.middle_name_native.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> PersonalDetails:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PersonalDetails JSON value must be an object")
        var known = List[String]()
        known.append("first_name")
        known.append("last_name")
        known.append("middle_name")
        known.append("birth_date")
        known.append("gender")
        known.append("country_code")
        known.append("residence_country_code")
        known.append("first_name_native")
        known.append("last_name_native")
        known.append("middle_name_native")
        return PersonalDetails(
            _passport_data_required_string(data, "first_name"),
            _passport_data_required_string(data, "last_name"),
            _passport_data_required_string(data, "birth_date"),
            _passport_data_required_string(data, "gender"),
            _passport_data_required_string(data, "country_code"),
            _passport_data_required_string(data, "residence_country_code"),
            _passport_data_optional_string(data, "first_name_native"),
            _passport_data_optional_string(data, "last_name_native"),
            _passport_data_optional_string(data, "middle_name"),
            _passport_data_optional_string(data, "middle_name_native"),
            api_kwargs=_passport_data_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[PersonalDetails]:
        var items = data.array_documents(array_index)
        var result = List[PersonalDetails]()
        for item in items:
            result.append(PersonalDetails.de_json(item.copy()))
        return result^


struct ResidentialAddress(Copyable, TelegramJsonObject):
    """Residential address details shared through Telegram Passport."""

    var street_line1: String
    var street_line2: String
    var city: String
    var state: String
    var country_code: String
    var post_code: String
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        street_line1: String,
        street_line2: String,
        city: String,
        state: String,
        country_code: String,
        post_code: String,
    ):
        self.street_line1 = street_line1.copy()
        self.street_line2 = street_line2.copy()
        self.city = city.copy()
        self.state = state.copy()
        self.country_code = country_code.copy()
        self.post_code = post_code.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        street_line1: String,
        street_line2: String,
        city: String,
        state: String,
        country_code: String,
        post_code: String,
        *,
        api_kwargs: JsonDocument,
    ):
        self.street_line1 = street_line1.copy()
        self.street_line2 = street_line2.copy()
        self.city = city.copy()
        self.state = state.copy()
        self.country_code = country_code.copy()
        self.post_code = post_code.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.street_line1 = existing.street_line1.copy()
        self.street_line2 = existing.street_line2.copy()
        self.city = existing.city.copy()
        self.state = existing.state.copy()
        self.country_code = existing.country_code.copy()
        self.post_code = existing.post_code.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "street_line1", self.street_line1)
        result.set_string(result.root, "street_line2", self.street_line2)
        result.set_string(result.root, "city", self.city)
        result.set_string(result.root, "state", self.state)
        result.set_string(result.root, "country_code", self.country_code)
        result.set_string(result.root, "post_code", self.post_code)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ResidentialAddress:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ResidentialAddress JSON value must be an object")
        var known = List[String]()
        known.append("street_line1")
        known.append("street_line2")
        known.append("city")
        known.append("state")
        known.append("country_code")
        known.append("post_code")
        return ResidentialAddress(
            _passport_data_required_string(data, "street_line1"),
            _passport_data_required_string(data, "street_line2"),
            _passport_data_required_string(data, "city"),
            _passport_data_required_string(data, "state"),
            _passport_data_required_string(data, "country_code"),
            _passport_data_required_string(data, "post_code"),
            api_kwargs=_passport_data_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ResidentialAddress]:
        var items = data.array_documents(array_index)
        var result = List[ResidentialAddress]()
        for item in items:
            result.append(ResidentialAddress.de_json(item.copy()))
        return result^


struct IdDocumentData(Copyable, TelegramJsonObject):
    """Identity document number and optional-form expiry date string."""

    var document_no: String
    var expiry_date: String
    var api_kwargs: JsonDocument

    def __init__(out self, document_no: String, expiry_date: String):
        self.document_no = document_no.copy()
        self.expiry_date = expiry_date.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self, document_no: String, expiry_date: String, *, api_kwargs: JsonDocument
    ):
        self.document_no = document_no.copy()
        self.expiry_date = expiry_date.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.document_no = existing.document_no.copy()
        self.expiry_date = existing.expiry_date.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "document_no", self.document_no)
        result.set_string(result.root, "expiry_date", self.expiry_date)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> IdDocumentData:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("IdDocumentData JSON value must be an object")
        var known = List[String]()
        known.append("document_no")
        known.append("expiry_date")
        return IdDocumentData(
            _passport_data_required_string(data, "document_no"),
            _passport_data_required_string(data, "expiry_date"),
            api_kwargs=_passport_data_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[IdDocumentData]:
        var items = data.array_documents(array_index)
        var result = List[IdDocumentData]()
        for item in items:
            result.append(IdDocumentData.de_json(item.copy()))
        return result^

