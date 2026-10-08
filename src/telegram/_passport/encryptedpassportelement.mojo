#!/usr/bin/env mojo
#
# Native EncryptedPassportElement model corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Encrypted Passport values and their attached document files."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._passport.credentials import (
    Credentials,
    FileCredentials,
    SecureValue,
    _passport_model_list,
    _passport_optional_model,
    _passport_set_model_list,
    _passport_set_optional_model,
    _passport_unknown_fields,
)
from telegram._passport._crypto import base64_decode, decrypt_passport_json
from telegram._passport.passportfile import PassportFile
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.error import PassportDecryptionError


def _passport_set_optional_document(
    mut result: JsonDocument, key: String, value: Optional[JsonDocument]
) raises:
    if value is None:
        return
    var nested = value.value().copy()
    var index = result.copy_subtree_from(nested, nested.root)
    result.object_set(result.root, key, index)


def _passport_json_node_equal(
    first: JsonDocument, first_index: Int, second: JsonDocument, second_index: Int
) -> Bool:
    if (
        first_index < 0 or first_index >= len(first.nodes)
        or second_index < 0 or second_index >= len(second.nodes)
    ):
        return False
    var first_node = first.nodes[first_index]
    var second_node = second.nodes[second_index]
    if (
        first_node.kind != second_node.kind
        or first_node.text != second_node.text
        or first_node.boolean != second_node.boolean
        or first_node.name != second_node.name
    ):
        return False
    var first_child = first_node.first_child
    var second_child = second_node.first_child
    while first_child != -1 and second_child != -1:
        if not _passport_json_node_equal(first, first_child, second, second_child):
            return False
        first_child = first.nodes[first_child].next_sibling
        second_child = second.nodes[second_child].next_sibling
    return first_child == -1 and second_child == -1


def _passport_element_data_equal(
    first: Optional[JsonDocument], second: Optional[JsonDocument]
) -> Bool:
    if first is None or second is None:
        return first is None and second is None
    return _passport_json_node_equal(
        first.value(), first.value().root, second.value(), second.value().root
    )


def _passport_hash_json_subtree[H: Hasher](mut hasher: H, data: JsonDocument, root: Int):
    var pending = List[Int]()
    pending.append(root)
    while len(pending) > 0:
        var index = pending.pop()
        var node = data.nodes[index]
        hasher.update(String(node.kind).as_bytes())
        hasher.update(node.name.as_bytes())
        hasher.update(node.text.as_bytes())
        hasher.update(String(node.boolean).as_bytes())
        var child = node.first_child
        while child != -1:
            pending.append(child)
            child = data.nodes[child].next_sibling


struct EncryptedPassportElement(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Passport field before decryption, with typed file attachments."""

    var type: String
    var hash: String
    var data: Optional[JsonDocument]
    var phone_number: Optional[String]
    var email: Optional[String]
    var files: List[PassportFile]
    var front_side: Optional[PassportFile]
    var reverse_side: Optional[PassportFile]
    var selfie: Optional[PassportFile]
    var translation: List[PassportFile]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        type: String,
        hash: String,
        data: Optional[JsonDocument] = None,
        phone_number: Optional[String] = None,
        email: Optional[String] = None,
        files: List[PassportFile] = List[PassportFile](),
        front_side: Optional[PassportFile] = None,
        reverse_side: Optional[PassportFile] = None,
        selfie: Optional[PassportFile] = None,
        translation: List[PassportFile] = List[PassportFile](),
    ):
        self.type = type.copy()
        self.hash = hash.copy()
        self.data = data.copy()
        self.phone_number = phone_number.copy()
        self.email = email.copy()
        self.files = files.copy()
        self.front_side = front_side.copy()
        self.reverse_side = reverse_side.copy()
        self.selfie = selfie.copy()
        self.translation = translation.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        type: String,
        hash: String,
        data: Optional[JsonDocument],
        phone_number: Optional[String],
        email: Optional[String],
        files: List[PassportFile],
        front_side: Optional[PassportFile],
        reverse_side: Optional[PassportFile],
        selfie: Optional[PassportFile],
        translation: List[PassportFile],
        *,
        api_kwargs: JsonDocument,
    ):
        self.type = type.copy()
        self.hash = hash.copy()
        self.data = data.copy()
        self.phone_number = phone_number.copy()
        self.email = email.copy()
        self.files = files.copy()
        self.front_side = front_side.copy()
        self.reverse_side = reverse_side.copy()
        self.selfie = selfie.copy()
        self.translation = translation.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.hash = existing.hash.copy()
        self.data = existing.data.copy()
        self.phone_number = existing.phone_number.copy()
        self.email = existing.email.copy()
        self.files = existing.files.copy()
        self.front_side = existing.front_side.copy()
        self.reverse_side = existing.reverse_side.copy()
        self.selfie = existing.selfie.copy()
        self.translation = existing.translation.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if (
            self.type != other.type
            or not _passport_element_data_equal(self.data, other.data)
            or self.phone_number != other.phone_number
            or self.email != other.email
            or self.front_side != other.front_side
            or self.reverse_side != other.reverse_side
            or self.selfie != other.selfie
            or len(self.files) != len(other.files)
        ):
            return False
        for index in range(len(self.files)):
            if self.files[index] != other.files[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.type.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.data is not None:
            _passport_hash_json_subtree(hasher, self.data.value(), self.data.value().root)
        hasher.update(String("\0").as_bytes())
        if self.phone_number is not None:
            hasher.update(self.phone_number.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.email is not None:
            hasher.update(self.email.value().as_bytes())
        for file in self.files:
            hasher.update(String(hash(file)).as_bytes())
            hasher.update(String("\0").as_bytes())
        if self.front_side is not None:
            hasher.update(String(hash(self.front_side.value())).as_bytes())
        if self.reverse_side is not None:
            hasher.update(String(hash(self.reverse_side.value())).as_bytes())
        if self.selfie is not None:
            hasher.update(String(hash(self.selfie.value())).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)
        result.set_string(result.root, "hash", self.hash)
        _passport_set_optional_document(result, "data", self.data)
        if self.phone_number is not None:
            result.set_string(result.root, "phone_number", self.phone_number.value())
        if self.email is not None:
            result.set_string(result.root, "email", self.email.value())
        _passport_set_model_list(result, "files", self.files, recursive)
        _passport_set_optional_model(result, "front_side", self.front_side, recursive)
        _passport_set_optional_model(result, "reverse_side", self.reverse_side, recursive)
        _passport_set_optional_model(result, "selfie", self.selfie, recursive)
        _passport_set_model_list(result, "translation", self.translation, recursive)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def de_json_decrypted(self, credentials: Credentials) raises -> Self:
        """Decode this encrypted element using its matching Passport credentials."""
        var result = self.copy()
        if self.type == "phone_number" or self.type == "email":
            return result^
        if credentials.secure_data is None:
            raise Error("Decrypted Passport credentials have no secure_data")

        var secure_data = credentials.secure_data.value().copy()
        var secure_value: Optional[SecureValue]
        if self.type == "personal_details":
            secure_value = secure_data.personal_details.copy()
        elif self.type == "passport":
            secure_value = secure_data.passport.copy()
        elif self.type == "internal_passport":
            secure_value = secure_data.internal_passport.copy()
        elif self.type == "driver_license":
            secure_value = secure_data.driver_license.copy()
        elif self.type == "identity_card":
            secure_value = secure_data.identity_card.copy()
        elif self.type == "address":
            secure_value = secure_data.address.copy()
        elif self.type == "utility_bill":
            secure_value = secure_data.utility_bill.copy()
        elif self.type == "bank_statement":
            secure_value = secure_data.bank_statement.copy()
        elif self.type == "rental_agreement":
            secure_value = secure_data.rental_agreement.copy()
        elif self.type == "passport_registration":
            secure_value = secure_data.passport_registration.copy()
        elif self.type == "temporary_registration":
            secure_value = secure_data.temporary_registration.copy()
        else:
            var unknown_index = secure_data.api_kwargs.object_get(
                secure_data.api_kwargs.root, self.type
            )
            if unknown_index == -1 or secure_data.api_kwargs.is_null(unknown_index):
                raise Error(String("Unknown EncryptedPassportElement type: ", self.type))
            var unknown_value = JsonDocument()
            unknown_value.root = unknown_value.copy_subtree_from(
                secure_data.api_kwargs, unknown_index
            )
            secure_value = Optional[SecureValue](SecureValue.de_json(unknown_value))

        if secure_value is None:
            raise Error(String("Missing secure Passport credentials for type ", self.type))
        var secure = secure_value.value().copy()
        if secure.data is not None and result.data is not None:
            var encrypted_data = result.data.value().copy()
            var data_kind = encrypted_data.nodes[encrypted_data.root].kind
            if data_kind != JSON_OBJECT:
                if data_kind != JSON_STRING:
                    raise PassportDecryptionError(
                        "Encrypted Passport element data must be a base64 string"
                    )
                var data_credentials = secure.data.value().copy()
                var clear = decrypt_passport_json(
                    base64_decode(data_credentials.secret),
                    base64_decode(data_credentials.hash),
                    base64_decode(encrypted_data.string_value(encrypted_data.root)),
                )
                result.data = Optional[JsonDocument](clear^)

        var decrypted_files = List[PassportFile]()
        for index in range(len(result.files)):
            if index >= len(secure.files):
                raise Error("Passport file credential count does not match encrypted files")
            decrypted_files.append(
                PassportFile.de_json_decrypted(
                    result.files[index].to_dict(), secure.files[index]
                )
            )
        result.files = decrypted_files^

        if result.front_side is not None and secure.front_side is not None:
            result.front_side = Optional[PassportFile](
                PassportFile.de_json_decrypted(
                    result.front_side.value().to_dict(), secure.front_side.value()
                )
            )
        if result.reverse_side is not None and secure.reverse_side is not None:
            result.reverse_side = Optional[PassportFile](
                PassportFile.de_json_decrypted(
                    result.reverse_side.value().to_dict(), secure.reverse_side.value()
                )
            )
        if result.selfie is not None and secure.selfie is not None:
            result.selfie = Optional[PassportFile](
                PassportFile.de_json_decrypted(
                    result.selfie.value().to_dict(), secure.selfie.value()
                )
            )

        var decrypted_translation = List[PassportFile]()
        for index in range(len(result.translation)):
            if index >= len(secure.translation):
                raise Error("Passport translation credential count does not match encrypted files")
            decrypted_translation.append(
                PassportFile.de_json_decrypted(
                    result.translation[index].to_dict(), secure.translation[index]
                )
            )
        result.translation = decrypted_translation^
        return result^

    @staticmethod
    def de_json(data: JsonDocument) raises -> EncryptedPassportElement:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("EncryptedPassportElement JSON value must be an object")
        var type_index = data.object_get(data.root, "type")
        var hash_index = data.object_get(data.root, "hash")
        if type_index == -1 or hash_index == -1:
            raise Error("EncryptedPassportElement JSON object is missing a required field")
        var parsed_data: Optional[JsonDocument] = None
        var data_index = data.object_get(data.root, "data")
        if data_index != -1 and not data.is_null(data_index):
            var nested = JsonDocument()
            nested.root = nested.copy_subtree_from(data, data_index)
            parsed_data = Optional[JsonDocument](nested^)
        var known = List[String]()
        known.append("type")
        known.append("hash")
        known.append("data")
        known.append("phone_number")
        known.append("email")
        known.append("files")
        known.append("front_side")
        known.append("reverse_side")
        known.append("selfie")
        known.append("translation")
        return EncryptedPassportElement(
            data.string_value(type_index),
            data.string_value(hash_index),
            parsed_data,
            _passport_optional_string(data, "phone_number"),
            _passport_optional_string(data, "email"),
            _passport_model_list[PassportFile](data, "files"),
            _passport_optional_model[PassportFile](data, "front_side"),
            _passport_optional_model[PassportFile](data, "reverse_side"),
            _passport_optional_model[PassportFile](data, "selfie"),
            _passport_model_list[PassportFile](data, "translation"),
            api_kwargs=_passport_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[EncryptedPassportElement]:
        var items = data.array_documents(array_index)
        var result = List[EncryptedPassportElement]()
        for item in items:
            result.append(EncryptedPassportElement.de_json(item.copy()))
        return result^


def _passport_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))
