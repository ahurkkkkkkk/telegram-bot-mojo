#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 Contact.
# LGPL-3.0-or-later; see LICENSE.

"""A Telegram phone contact and its Bot API JSON conversion."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct Contact(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A phone contact. Equality follows upstream and uses only ``phone_number``."""

    var phone_number: String
    var first_name: String
    var last_name: Optional[String]
    var user_id: Optional[Int]
    var vcard: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        phone_number: String,
        first_name: String,
        last_name: Optional[String] = None,
        user_id: Optional[Int] = None,
        vcard: Optional[String] = None,
    ):
        self.phone_number = phone_number.copy()
        self.first_name = first_name.copy()
        self.last_name = last_name
        self.user_id = user_id
        self.vcard = vcard
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        phone_number: String,
        first_name: String,
        last_name: Optional[String] = None,
        user_id: Optional[Int] = None,
        vcard: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.phone_number = phone_number.copy()
        self.first_name = first_name.copy()
        self.last_name = last_name
        self.user_id = user_id
        self.vcard = vcard
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.phone_number = existing.phone_number.copy()
        self.first_name = existing.first_name.copy()
        self.last_name = existing.last_name
        self.user_id = existing.user_id
        self.vcard = existing.vcard
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.phone_number == other.phone_number

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.phone_number.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "phone_number", self.phone_number)
        result.set_string(result.root, "first_name", self.first_name)
        if self.last_name is not None:
            result.set_string(result.root, "last_name", self.last_name.value())
        if self.user_id is not None:
            result.set_number(result.root, "user_id", String(self.user_id.value()))
        if self.vcard is not None:
            result.set_string(result.root, "vcard", self.vcard.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("Contact JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("Contact JSON value is not an object")

        var phone_number_index = data.object_get(data.root, "phone_number")
        var first_name_index = data.object_get(data.root, "first_name")
        if phone_number_index == -1 or first_name_index == -1:
            raise Error("Contact JSON object is missing a required field")
        var phone_number = data.string_value(phone_number_index)
        var first_name = data.string_value(first_name_index)

        var last_name: Optional[String] = None
        var last_name_index = data.object_get(data.root, "last_name")
        if last_name_index != -1 and not data.is_null(last_name_index):
            last_name = Optional[String](data.string_value(last_name_index))

        var user_id: Optional[Int] = None
        var user_id_index = data.object_get(data.root, "user_id")
        if user_id_index != -1 and not data.is_null(user_id_index):
            user_id = Optional[Int](data.integer_value(user_id_index))

        var vcard: Optional[String] = None
        var vcard_index = data.object_get(data.root, "vcard")
        if vcard_index != -1 and not data.is_null(vcard_index):
            vcard = Optional[String](data.string_value(vcard_index))

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "phone_number"
                and key != "first_name"
                and key != "last_name"
                and key != "user_id"
                and key != "vcard"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling

        return Contact(
            phone_number,
            first_name,
            last_name,
            user_id,
            vcard,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Contact.de_json(items[index].copy()))
        return result^
