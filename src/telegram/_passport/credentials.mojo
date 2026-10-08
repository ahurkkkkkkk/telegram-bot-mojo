#!/usr/bin/env mojo
#
# Native Mojo scalar-model translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native scalar Telegram models translated from _passport/credentials.py."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._passport._crypto import (
    base64_decode,
    decrypt_passport_json,
    rsa_oaep_sha1_decrypt,
)


def _passport_optional_model[T: TelegramJsonObject](
    data: JsonDocument, key: String
) raises -> Optional[T]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    var nested = JsonDocument()
    nested.root = nested.copy_subtree_from(data, index)
    return Optional[T](T.de_json(nested))


def _passport_model_list[T: TelegramJsonObject & Deinitable](
    data: JsonDocument, key: String
) raises -> List[T]:
    var index = data.object_get(data.root, key)
    var result = List[T]()
    if index == -1 or data.is_null(index):
        return result^
    var items = data.array_documents(index)
    for item in items:
        result.append(T.de_json(item.copy()))
    return result^


def _passport_set_optional_model[T: TelegramJsonObject](
    mut result: JsonDocument, key: String, value: Optional[T], recursive: Bool
) raises:
    if value is None:
        return
    var nested = value.value().to_dict(recursive=recursive)
    var index = result.copy_subtree_from(nested, nested.root)
    result.object_set(result.root, key, index)


def _passport_set_model_list[T: TelegramJsonObject](
    mut result: JsonDocument, key: String, values: List[T], recursive: Bool
) raises:
    if len(values) == 0:
        return
    var array_index = result.add_array()
    for value in values:
        var nested = value.to_dict(recursive=recursive)
        var nested_index = result.copy_subtree_from(nested, nested.root)
        result.append_child(array_index, nested_index)
    result.object_set(result.root, key, array_index)


def _passport_unknown_fields(data: JsonDocument, known: List[String]) raises -> JsonDocument:
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


struct SecureValue(Copyable, TelegramJsonObject):
    """The hashes and secrets used to decrypt one Telegram Passport value."""

    var data: Optional[DataCredentials]
    var front_side: Optional[FileCredentials]
    var reverse_side: Optional[FileCredentials]
    var selfie: Optional[FileCredentials]
    var files: List[FileCredentials]
    var translation: List[FileCredentials]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        data: Optional[DataCredentials] = None,
        front_side: Optional[FileCredentials] = None,
        reverse_side: Optional[FileCredentials] = None,
        selfie: Optional[FileCredentials] = None,
        files: List[FileCredentials] = List[FileCredentials](),
        translation: List[FileCredentials] = List[FileCredentials](),
    ):
        self.data = data.copy()
        self.front_side = front_side.copy()
        self.reverse_side = reverse_side.copy()
        self.selfie = selfie.copy()
        self.files = files.copy()
        self.translation = translation.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        data: Optional[DataCredentials],
        front_side: Optional[FileCredentials],
        reverse_side: Optional[FileCredentials],
        selfie: Optional[FileCredentials],
        files: List[FileCredentials],
        translation: List[FileCredentials],
        *,
        api_kwargs: JsonDocument,
    ):
        self.data = data.copy()
        self.front_side = front_side.copy()
        self.reverse_side = reverse_side.copy()
        self.selfie = selfie.copy()
        self.files = files.copy()
        self.translation = translation.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.data = existing.data.copy()
        self.front_side = existing.front_side.copy()
        self.reverse_side = existing.reverse_side.copy()
        self.selfie = existing.selfie.copy()
        self.files = existing.files.copy()
        self.translation = existing.translation.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        _passport_set_optional_model(result, "data", self.data, recursive)
        _passport_set_optional_model(result, "front_side", self.front_side, recursive)
        _passport_set_optional_model(result, "reverse_side", self.reverse_side, recursive)
        _passport_set_optional_model(result, "selfie", self.selfie, recursive)
        _passport_set_model_list(result, "files", self.files, recursive)
        _passport_set_model_list(result, "translation", self.translation, recursive)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> SecureValue:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("SecureValue JSON value must be an object")
        var known = List[String]()
        known.append("data")
        known.append("front_side")
        known.append("reverse_side")
        known.append("selfie")
        known.append("files")
        known.append("translation")
        return SecureValue(
            _passport_optional_model[DataCredentials](data, "data"),
            _passport_optional_model[FileCredentials](data, "front_side"),
            _passport_optional_model[FileCredentials](data, "reverse_side"),
            _passport_optional_model[FileCredentials](data, "selfie"),
            _passport_model_list[FileCredentials](data, "files"),
            _passport_model_list[FileCredentials](data, "translation"),
            api_kwargs=_passport_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[SecureValue]:
        var items = data.array_documents(array_index)
        var result = List[SecureValue]()
        for item in items:
            result.append(SecureValue.de_json(item.copy()))
        return result^


struct SecureData(Copyable, TelegramJsonObject):
    """Credential bundles for the supported encrypted Passport element types."""

    var personal_details: Optional[SecureValue]
    var passport: Optional[SecureValue]
    var internal_passport: Optional[SecureValue]
    var driver_license: Optional[SecureValue]
    var identity_card: Optional[SecureValue]
    var address: Optional[SecureValue]
    var utility_bill: Optional[SecureValue]
    var bank_statement: Optional[SecureValue]
    var rental_agreement: Optional[SecureValue]
    var passport_registration: Optional[SecureValue]
    var temporary_registration: Optional[SecureValue]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        personal_details: Optional[SecureValue] = None,
        passport: Optional[SecureValue] = None,
        internal_passport: Optional[SecureValue] = None,
        driver_license: Optional[SecureValue] = None,
        identity_card: Optional[SecureValue] = None,
        address: Optional[SecureValue] = None,
        utility_bill: Optional[SecureValue] = None,
        bank_statement: Optional[SecureValue] = None,
        rental_agreement: Optional[SecureValue] = None,
        passport_registration: Optional[SecureValue] = None,
        temporary_registration: Optional[SecureValue] = None,
    ):
        self.personal_details = personal_details.copy()
        self.passport = passport.copy()
        self.internal_passport = internal_passport.copy()
        self.driver_license = driver_license.copy()
        self.identity_card = identity_card.copy()
        self.address = address.copy()
        self.utility_bill = utility_bill.copy()
        self.bank_statement = bank_statement.copy()
        self.rental_agreement = rental_agreement.copy()
        self.passport_registration = passport_registration.copy()
        self.temporary_registration = temporary_registration.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        personal_details: Optional[SecureValue],
        passport: Optional[SecureValue],
        internal_passport: Optional[SecureValue],
        driver_license: Optional[SecureValue],
        identity_card: Optional[SecureValue],
        address: Optional[SecureValue],
        utility_bill: Optional[SecureValue],
        bank_statement: Optional[SecureValue],
        rental_agreement: Optional[SecureValue],
        passport_registration: Optional[SecureValue],
        temporary_registration: Optional[SecureValue],
        *,
        api_kwargs: JsonDocument,
    ):
        self.personal_details = personal_details.copy()
        self.passport = passport.copy()
        self.internal_passport = internal_passport.copy()
        self.driver_license = driver_license.copy()
        self.identity_card = identity_card.copy()
        self.address = address.copy()
        self.utility_bill = utility_bill.copy()
        self.bank_statement = bank_statement.copy()
        self.rental_agreement = rental_agreement.copy()
        self.passport_registration = passport_registration.copy()
        self.temporary_registration = temporary_registration.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.personal_details = existing.personal_details.copy()
        self.passport = existing.passport.copy()
        self.internal_passport = existing.internal_passport.copy()
        self.driver_license = existing.driver_license.copy()
        self.identity_card = existing.identity_card.copy()
        self.address = existing.address.copy()
        self.utility_bill = existing.utility_bill.copy()
        self.bank_statement = existing.bank_statement.copy()
        self.rental_agreement = existing.rental_agreement.copy()
        self.passport_registration = existing.passport_registration.copy()
        self.temporary_registration = existing.temporary_registration.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        _passport_set_optional_model(result, "personal_details", self.personal_details, recursive)
        _passport_set_optional_model(result, "passport", self.passport, recursive)
        _passport_set_optional_model(result, "internal_passport", self.internal_passport, recursive)
        _passport_set_optional_model(result, "driver_license", self.driver_license, recursive)
        _passport_set_optional_model(result, "identity_card", self.identity_card, recursive)
        _passport_set_optional_model(result, "address", self.address, recursive)
        _passport_set_optional_model(result, "utility_bill", self.utility_bill, recursive)
        _passport_set_optional_model(result, "bank_statement", self.bank_statement, recursive)
        _passport_set_optional_model(result, "rental_agreement", self.rental_agreement, recursive)
        _passport_set_optional_model(result, "passport_registration", self.passport_registration, recursive)
        _passport_set_optional_model(result, "temporary_registration", self.temporary_registration, recursive)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> SecureData:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("SecureData JSON value must be an object")
        var known = List[String]()
        known.append("personal_details")
        known.append("passport")
        known.append("internal_passport")
        known.append("driver_license")
        known.append("identity_card")
        known.append("address")
        known.append("utility_bill")
        known.append("bank_statement")
        known.append("rental_agreement")
        known.append("passport_registration")
        known.append("temporary_registration")
        return SecureData(
            _passport_optional_model[SecureValue](data, "personal_details"),
            _passport_optional_model[SecureValue](data, "passport"),
            _passport_optional_model[SecureValue](data, "internal_passport"),
            _passport_optional_model[SecureValue](data, "driver_license"),
            _passport_optional_model[SecureValue](data, "identity_card"),
            _passport_optional_model[SecureValue](data, "address"),
            _passport_optional_model[SecureValue](data, "utility_bill"),
            _passport_optional_model[SecureValue](data, "bank_statement"),
            _passport_optional_model[SecureValue](data, "rental_agreement"),
            _passport_optional_model[SecureValue](data, "passport_registration"),
            _passport_optional_model[SecureValue](data, "temporary_registration"),
            api_kwargs=_passport_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[SecureData]:
        var items = data.array_documents(array_index)
        var result = List[SecureData]()
        for item in items:
            result.append(SecureData.de_json(item.copy()))
        return result^


struct Credentials(Copyable, TelegramJsonObject):
    """Decrypted Passport credentials and the nonce supplied by the bot."""

    var secure_data: Optional[SecureData]
    var nonce: String
    var api_kwargs: JsonDocument

    def __init__(out self, secure_data: Optional[SecureData], nonce: String):
        self.secure_data = secure_data.copy()
        self.nonce = nonce.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        secure_data: Optional[SecureData],
        nonce: String,
        *,
        api_kwargs: JsonDocument,
    ):
        self.secure_data = secure_data.copy()
        self.nonce = nonce.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.secure_data = existing.secure_data.copy()
        self.nonce = existing.nonce.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        _passport_set_optional_model(result, "secure_data", self.secure_data, recursive)
        result.set_string(result.root, "nonce", self.nonce)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Credentials:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Credentials JSON value must be an object")
        var nonce_index = data.object_get(data.root, "nonce")
        if nonce_index == -1:
            raise Error("Credentials JSON object is missing nonce")
        var known = List[String]()
        known.append("secure_data")
        known.append("nonce")
        return Credentials(
            _passport_optional_model[SecureData](data, "secure_data"),
            data.string_value(nonce_index),
            api_kwargs=_passport_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Credentials]:
        var items = data.array_documents(array_index)
        var result = List[Credentials]()
        for item in items:
            result.append(Credentials.de_json(item.copy()))
        return result^


struct DataCredentials(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native data-hash and secret credentials for Telegram Passport data."""

    var hash: String
    var secret: String
    var data_hash: String
    var file_hash: String
    var api_kwargs: JsonDocument

    def __init__(out self, data_hash: String, secret: String):
        self.hash = data_hash.copy()
        self.secret = secret.copy()
        self.data_hash = data_hash.copy()
        self.file_hash = data_hash.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self, data_hash: String, secret: String, *, api_kwargs: JsonDocument
    ):
        self.hash = data_hash.copy()
        self.secret = secret.copy()
        self.data_hash = data_hash.copy()
        self.file_hash = data_hash.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.hash = existing.hash.copy()
        self.secret = existing.secret.copy()
        self.data_hash = existing.data_hash.copy()
        self.file_hash = existing.file_hash.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.hash == other.hash and self.secret == other.secret

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.hash.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.secret.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "hash", self.hash)
        result.set_string(result.root, "secret", self.secret)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> DataCredentials:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("DataCredentials JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("DataCredentials JSON value is not an object")
        var hash_index = data.object_get(data.root, "hash")
        var secret_index = data.object_get(data.root, "secret")
        if hash_index == -1 or secret_index == -1:
            raise Error("DataCredentials JSON object is missing a required field")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "hash" and key != "secret":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return DataCredentials(
            data.string_value(hash_index), data.string_value(secret_index), api_kwargs=api_kwargs
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[DataCredentials]:
        var items = data.array_documents(array_index)
        var result = List[DataCredentials]()
        for index in range(len(items)):
            result.append(DataCredentials.de_json(items[index].copy()))
        return result^


struct FileCredentials(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native file-hash and secret credentials for Telegram Passport files."""

    var hash: String
    var secret: String
    var file_hash: String
    var data_hash: String
    var api_kwargs: JsonDocument

    def __init__(out self, file_hash: String, secret: String):
        self.hash = file_hash.copy()
        self.secret = secret.copy()
        self.file_hash = file_hash.copy()
        self.data_hash = file_hash.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self, file_hash: String, secret: String, *, api_kwargs: JsonDocument
    ):
        self.hash = file_hash.copy()
        self.secret = secret.copy()
        self.file_hash = file_hash.copy()
        self.data_hash = file_hash.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.hash = existing.hash.copy()
        self.secret = existing.secret.copy()
        self.file_hash = existing.file_hash.copy()
        self.data_hash = existing.data_hash.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.hash == other.hash and self.secret == other.secret

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.hash.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.secret.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "hash", self.hash)
        result.set_string(result.root, "secret", self.secret)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> FileCredentials:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("FileCredentials JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("FileCredentials JSON value is not an object")
        var hash_index = data.object_get(data.root, "hash")
        var secret_index = data.object_get(data.root, "secret")
        if hash_index == -1 or secret_index == -1:
            raise Error("FileCredentials JSON object is missing a required field")
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "hash" and key != "secret":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return FileCredentials(
            data.string_value(hash_index), data.string_value(secret_index), api_kwargs=api_kwargs
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[FileCredentials]:
        var items = data.array_documents(array_index)
        var result = List[FileCredentials]()
        for index in range(len(items)):
            result.append(FileCredentials.de_json(items[index].copy()))
        return result^


struct EncryptedCredentials(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native scalar-field port of upstream EncryptedCredentials."""

    var data: String
    var hash: String
    var secret: String
    var api_kwargs: JsonDocument

    def __init__(out self, data: String, hash: String, secret: String):
        self.data = data
        self.hash = hash
        self.secret = secret
        self.api_kwargs = empty_json_object()

    def __init__(out self, data: String, hash: String, secret: String, api_kwargs: JsonDocument):
        self.data = data
        self.hash = hash
        self.secret = secret
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.data = existing.data.copy()
        self.hash = existing.hash.copy()
        self.secret = existing.secret.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.data == other.data and self.hash == other.hash and self.secret == other.secret

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.data.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.hash.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.secret.as_bytes())

    def decrypt_data(self, decrypted_secret: List[UInt8]) raises -> Credentials:
        """Decrypt and authenticate the embedded Credentials JSON with an RSA-decoded secret."""
        var expected_hash = base64_decode(self.hash)
        var ciphertext = base64_decode(self.data)
        var decrypted = decrypt_passport_json(
            decrypted_secret, expected_hash, ciphertext
        )
        return Credentials.de_json(decrypted)

    def decrypt_with_private_key(
        self, private_key_pem: String, password: Optional[String] = None
    ) raises -> Credentials:
        """Decrypt both the RSA-wrapped secret and authenticated credentials JSON."""
        var encrypted_secret = base64_decode(self.secret)
        var secret = rsa_oaep_sha1_decrypt(
            private_key_pem, encrypted_secret, password
        )
        return self.decrypt_data(secret)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "data", self.data)
        result.set_string(result.root, "hash", self.hash)
        result.set_string(result.root, "secret", self.secret)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> EncryptedCredentials:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("EncryptedCredentials JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("EncryptedCredentials JSON value is not an object")
        var parsed_data_index = data.object_get(data.root, "data")
        if parsed_data_index == -1:
            raise Error("EncryptedCredentials JSON object is missing data")
        var parsed_data = data.string_value(parsed_data_index)
        var parsed_hash_index = data.object_get(data.root, "hash")
        if parsed_hash_index == -1:
            raise Error("EncryptedCredentials JSON object is missing hash")
        var parsed_hash = data.string_value(parsed_hash_index)
        var parsed_secret_index = data.object_get(data.root, "secret")
        if parsed_secret_index == -1:
            raise Error("EncryptedCredentials JSON object is missing secret")
        var parsed_secret = data.string_value(parsed_secret_index)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "data" and key != "hash" and key != "secret":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return EncryptedCredentials(parsed_data, parsed_hash, parsed_secret, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[EncryptedCredentials]:
        var items = data.array_documents(array_index)
        var result = List[EncryptedCredentials]()
        for index in range(len(items)):
            result.append(EncryptedCredentials.de_json(items[index].copy()))
        return result^
