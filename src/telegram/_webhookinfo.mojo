#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 _webhookinfo.py.
# LGPL-3.0-or-later; see LICENSE.

"""Status information for the bot's configured Telegram webhook."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_ARRAY, JSON_BOOL, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _webhook_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    if data.nodes[index].kind != JSON_STRING:
        raise Error(String("WebhookInfo field ", key, " must be a string or null"))
    return Optional[String](data.string_value(index))


def _webhook_optional_int(data: JsonDocument, key: String) raises -> Optional[Int]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Int](data.integer_value(index))


def _webhook_optional_date(
    data: JsonDocument, key: String
) raises -> Optional[TimestampDateTime]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[TimestampDateTime](from_timestamp(data.integer_value(index)))


def _webhook_api_kwargs(data: JsonDocument) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var known = (
            key == "allowed_updates" or key == "has_custom_certificate"
            or key == "ip_address" or key == "last_error_date"
            or key == "last_error_message" or key == "last_synchronization_error_date"
            or key == "max_connections" or key == "pending_update_count" or key == "url"
        )
        if not known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct WebhookInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Webhook delivery status and configuration reported by Telegram."""

    var allowed_updates: List[String]
    var has_custom_certificate: Bool
    var ip_address: Optional[String]
    var last_error_date: Optional[TimestampDateTime]
    var last_error_message: Optional[String]
    var last_synchronization_error_date: Optional[TimestampDateTime]
    var max_connections: Optional[Int]
    var pending_update_count: Int
    var url: String
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        url: String,
        has_custom_certificate: Bool,
        pending_update_count: Int,
        last_error_date: Optional[TimestampDateTime] = None,
        last_error_message: Optional[String] = None,
        max_connections: Optional[Int] = None,
        allowed_updates: List[String] = List[String](),
        ip_address: Optional[String] = None,
        last_synchronization_error_date: Optional[TimestampDateTime] = None,
    ):
        self.allowed_updates = allowed_updates.copy()
        self.has_custom_certificate = has_custom_certificate
        self.ip_address = ip_address.copy()
        self.last_error_date = last_error_date.copy()
        self.last_error_message = last_error_message.copy()
        self.last_synchronization_error_date = last_synchronization_error_date.copy()
        self.max_connections = max_connections
        self.pending_update_count = pending_update_count
        self.url = url.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        url: String,
        has_custom_certificate: Bool,
        pending_update_count: Int,
        last_error_date: Optional[TimestampDateTime] = None,
        last_error_message: Optional[String] = None,
        max_connections: Optional[Int] = None,
        allowed_updates: List[String] = List[String](),
        ip_address: Optional[String] = None,
        last_synchronization_error_date: Optional[TimestampDateTime] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.allowed_updates = allowed_updates.copy()
        self.has_custom_certificate = has_custom_certificate
        self.ip_address = ip_address.copy()
        self.last_error_date = last_error_date.copy()
        self.last_error_message = last_error_message.copy()
        self.last_synchronization_error_date = last_synchronization_error_date.copy()
        self.max_connections = max_connections
        self.pending_update_count = pending_update_count
        self.url = url.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.allowed_updates = existing.allowed_updates.copy()
        self.has_custom_certificate = existing.has_custom_certificate
        self.ip_address = existing.ip_address.copy()
        self.last_error_date = existing.last_error_date.copy()
        self.last_error_message = existing.last_error_message.copy()
        self.last_synchronization_error_date = existing.last_synchronization_error_date.copy()
        self.max_connections = existing.max_connections
        self.pending_update_count = existing.pending_update_count
        self.url = existing.url.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.url == other.url
            and self.has_custom_certificate == other.has_custom_certificate
            and self.pending_update_count == other.pending_update_count
            and self.ip_address == other.ip_address
            and self.last_error_date == other.last_error_date
            and self.last_error_message == other.last_error_message
            and self.max_connections == other.max_connections
            and self.allowed_updates == other.allowed_updates
            and self.last_synchronization_error_date == other.last_synchronization_error_date
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.url.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.has_custom_certificate:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.pending_update_count).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.ip_address is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(self.ip_address.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.last_error_date is None:
            hasher.update(String("None").as_bytes())
        else:
            var value = self.last_error_date.value().copy()
            hasher.update(String(hash(value)).as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.last_error_message is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(self.last_error_message.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.max_connections is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(String(self.max_connections.value()).as_bytes())
        for update_type in self.allowed_updates:
            hasher.update(String("\0").as_bytes())
            hasher.update(update_type.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.last_synchronization_error_date is None:
            hasher.update(String("None").as_bytes())
        else:
            var value = self.last_synchronization_error_date.value().copy()
            hasher.update(String(hash(value)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if len(self.allowed_updates) > 0:
            var updates = result.add_array()
            result.object_set(result.root, "allowed_updates", updates)
            for update_type in self.allowed_updates:
                var item = result.add_string(update_type.copy())
                result.append_child(updates, item)
        result.set_boolean(result.root, "has_custom_certificate", self.has_custom_certificate)
        if self.ip_address is not None:
            result.set_string(result.root, "ip_address", self.ip_address.value())
        if self.last_error_date is not None:
            result.set_number(
                result.root, "last_error_date", String(to_timestamp(self.last_error_date.value()))
            )
        if self.last_error_message is not None:
            result.set_string(result.root, "last_error_message", self.last_error_message.value())
        if self.last_synchronization_error_date is not None:
            result.set_number(
                result.root, "last_synchronization_error_date",
                String(to_timestamp(self.last_synchronization_error_date.value())),
            )
        if self.max_connections is not None:
            result.set_number(result.root, "max_connections", String(self.max_connections.value()))
        result.set_number(result.root, "pending_update_count", String(self.pending_update_count))
        result.set_string(result.root, "url", self.url)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("WebhookInfo JSON value must be an object")
        var url_index = data.object_get(data.root, "url")
        var certificate_index = data.object_get(data.root, "has_custom_certificate")
        var count_index = data.object_get(data.root, "pending_update_count")
        if url_index == -1 or certificate_index == -1 or count_index == -1:
            raise Error("WebhookInfo JSON object is missing a required field")
        if data.nodes[url_index].kind != JSON_STRING or data.nodes[certificate_index].kind != JSON_BOOL:
            raise Error("WebhookInfo required field has the wrong JSON type")
        var url = data.string_value(url_index)
        var has_custom_certificate = data.boolean_value(certificate_index)
        var pending_update_count = data.integer_value(count_index)
        var allowed_updates = List[String]()
        var updates_index = data.object_get(data.root, "allowed_updates")
        if updates_index != -1 and not data.is_null(updates_index):
            if data.nodes[updates_index].kind != JSON_ARRAY:
                raise Error("WebhookInfo allowed_updates must be an array or null")
            var updates = data.array_documents(updates_index)
            for update in updates:
                if update.root < 0 or update.nodes[update.root].kind != JSON_STRING:
                    raise Error("WebhookInfo allowed_updates entries must be strings")
                allowed_updates.append(update.string_value(update.root))
        var ip_address = _webhook_optional_string(data, "ip_address")
        var last_error_date = _webhook_optional_date(data, "last_error_date")
        var last_error_message = _webhook_optional_string(data, "last_error_message")
        var last_synchronization_error_date = _webhook_optional_date(
            data, "last_synchronization_error_date"
        )
        var max_connections = _webhook_optional_int(data, "max_connections")
        var api_kwargs = _webhook_api_kwargs(data)
        return Self(
            url, has_custom_certificate, pending_update_count, last_error_date,
            last_error_message, max_connections, allowed_updates, ip_address,
            last_synchronization_error_date, api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^
