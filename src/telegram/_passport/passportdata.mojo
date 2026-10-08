#!/usr/bin/env mojo
#
# Native PassportData model corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Encrypted Passport data and the credentials needed for its decryption."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._passport.credentials import Credentials, EncryptedCredentials
from telegram._passport.encryptedpassportelement import EncryptedPassportElement
from telegram._passport._crypto import base64_decode, rsa_oaep_sha1_decrypt
from telegram._bot import Bot
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct PassportData(Equatable, Hashable, Copyable, TelegramJsonObject):
    """An encrypted Passport payload; equality follows element types and credential hash."""

    var data: List[EncryptedPassportElement]
    var credentials: EncryptedCredentials
    var api_kwargs: JsonDocument

    def __init__(
        out self, data: List[EncryptedPassportElement], credentials: EncryptedCredentials
    ):
        self.data = data.copy()
        self.credentials = credentials.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        data: List[EncryptedPassportElement],
        credentials: EncryptedCredentials,
        *,
        api_kwargs: JsonDocument,
    ):
        self.data = data.copy()
        self.credentials = credentials.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.data = existing.data.copy()
        self.credentials = existing.credentials.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.credentials.hash != other.credentials.hash or len(self.data) != len(other.data):
            return False
        for index in range(len(self.data)):
            if self.data[index].type != other.data[index].type:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        for element in self.data:
            hasher.update(element.type.as_bytes())
            hasher.update(String("\0").as_bytes())
        hasher.update(self.credentials.hash.as_bytes())

    def decrypt_credentials(self, decrypted_secret: List[UInt8]) raises -> Credentials:
        """Decrypt authenticated Passport credential JSON using an RSA-decoded secret."""
        return self.credentials.decrypt_data(decrypted_secret)

    def decrypt_data(self, decrypted_secret: List[UInt8]) raises -> List[EncryptedPassportElement]:
        """Decrypt every element using credentials decoded from the payload."""
        var credentials = self.decrypt_credentials(decrypted_secret)
        var result = List[EncryptedPassportElement]()
        for element in self.data:
            result.append(element.de_json_decrypted(credentials))
        return result^

    def decrypt_credentials_with_bot(self, bot: Bot) raises -> Credentials:
        """Decrypt credentials using the RSA private key configured on a Bot."""
        var secret = bot.decrypt_private_secret(self.credentials.secret)
        return self.decrypt_credentials(secret)

    def decrypt_data_with_bot(self, bot: Bot) raises -> List[EncryptedPassportElement]:
        """Decrypt all Passport elements using the Bot's RSA private key."""
        var secret = bot.decrypt_private_secret(self.credentials.secret)
        return self.decrypt_data(secret)

    def decrypt_data_with_private_key(
        self, private_key_pem: String, password: Optional[String] = None
    ) raises -> List[EncryptedPassportElement]:
        """Decrypt the RSA-wrapped credentials and every element with a PEM key."""
        var encrypted_secret = base64_decode(self.credentials.secret)
        var secret = rsa_oaep_sha1_decrypt(
            private_key_pem, encrypted_secret, password
        )
        return self.decrypt_data(secret)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if len(self.data) > 0:
            var array_index = result.add_array()
            for element in self.data:
                var nested = element.to_dict(recursive=recursive)
                var index = result.copy_subtree_from(nested, nested.root)
                result.append_child(array_index, index)
            result.object_set(result.root, "data", array_index)
        var credentials_data = self.credentials.to_dict(recursive=recursive)
        var credentials_index = result.copy_subtree_from(
            credentials_data, credentials_data.root
        )
        result.object_set(result.root, "credentials", credentials_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> PassportData:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("PassportData JSON value must be an object")
        var credentials_index = data.object_get(data.root, "credentials")
        if credentials_index == -1 or data.is_null(credentials_index):
            raise Error("PassportData JSON object is missing credentials")
        var credentials_data = JsonDocument()
        credentials_data.root = credentials_data.copy_subtree_from(data, credentials_index)
        var items = List[EncryptedPassportElement]()
        var data_index = data.object_get(data.root, "data")
        if data_index != -1 and not data.is_null(data_index):
            var element_documents = data.array_documents(data_index)
            for element_data in element_documents:
                items.append(EncryptedPassportElement.de_json(element_data.copy()))
        var unknown = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            var recognized = key == "data" or key == "credentials"
            if not recognized:
                var copied = unknown.copy_subtree_from(data, child)
                unknown.object_set(unknown.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return PassportData(
            items,
            EncryptedCredentials.de_json(credentials_data),
            api_kwargs=unknown,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[PassportData]:
        var items = data.array_documents(array_index)
        var result = List[PassportData]()
        for item in items:
            result.append(PassportData.de_json(item.copy()))
        return result^
