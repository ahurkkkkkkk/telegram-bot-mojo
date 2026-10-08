#!/usr/bin/env mojo
#
# Native Telegram Business models translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native Telegram Business models translated from _business.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._files.location import Location
from telegram._files.sticker import Sticker
from telegram._businessopeninghoursinterval import BusinessOpeningHoursInterval
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _business_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("Business model JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _business_int_list(data: JsonDocument, index: Int) raises -> List[Int]:
    if index < 0 or index >= len(data.nodes) or data.nodes[index].kind != JSON_ARRAY:
        raise Error("BusinessMessagesDeleted message_ids must be a JSON array")
    var result = List[Int]()
    var child = data.nodes[index].first_child
    while child != -1:
        result.append(data.integer_value(child))
        child = data.nodes[child].next_sibling
    return result^


def _business_unknown_fields(data: JsonDocument, known: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var is_known = False
        for key in known:
            if key == data.nodes[child].name:
                is_known = True
                break
        if not is_known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, data.nodes[child].name.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^

struct BusinessBotRights(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream BusinessBotRights."""

    var can_reply: Optional[Bool]
    var can_read_messages: Optional[Bool]
    var can_delete_sent_messages: Optional[Bool]
    var can_delete_all_messages: Optional[Bool]
    var can_edit_name: Optional[Bool]
    var can_edit_bio: Optional[Bool]
    var can_edit_profile_photo: Optional[Bool]
    var can_edit_username: Optional[Bool]
    var can_change_gift_settings: Optional[Bool]
    var can_view_gifts_and_stars: Optional[Bool]
    var can_convert_gifts_to_stars: Optional[Bool]
    var can_transfer_and_upgrade_gifts: Optional[Bool]
    var can_transfer_stars: Optional[Bool]
    var can_manage_stories: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, can_reply: Optional[Bool] = None, can_read_messages: Optional[Bool] = None, can_delete_sent_messages: Optional[Bool] = None, can_delete_all_messages: Optional[Bool] = None, can_edit_name: Optional[Bool] = None, can_edit_bio: Optional[Bool] = None, can_edit_profile_photo: Optional[Bool] = None, can_edit_username: Optional[Bool] = None, can_change_gift_settings: Optional[Bool] = None, can_view_gifts_and_stars: Optional[Bool] = None, can_convert_gifts_to_stars: Optional[Bool] = None, can_transfer_and_upgrade_gifts: Optional[Bool] = None, can_transfer_stars: Optional[Bool] = None, can_manage_stories: Optional[Bool] = None):
        self.can_reply = can_reply
        self.can_read_messages = can_read_messages
        self.can_delete_sent_messages = can_delete_sent_messages
        self.can_delete_all_messages = can_delete_all_messages
        self.can_edit_name = can_edit_name
        self.can_edit_bio = can_edit_bio
        self.can_edit_profile_photo = can_edit_profile_photo
        self.can_edit_username = can_edit_username
        self.can_change_gift_settings = can_change_gift_settings
        self.can_view_gifts_and_stars = can_view_gifts_and_stars
        self.can_convert_gifts_to_stars = can_convert_gifts_to_stars
        self.can_transfer_and_upgrade_gifts = can_transfer_and_upgrade_gifts
        self.can_transfer_stars = can_transfer_stars
        self.can_manage_stories = can_manage_stories
        self.api_kwargs = empty_json_object()

    def __init__(out self, can_reply: Optional[Bool] = None, can_read_messages: Optional[Bool] = None, can_delete_sent_messages: Optional[Bool] = None, can_delete_all_messages: Optional[Bool] = None, can_edit_name: Optional[Bool] = None, can_edit_bio: Optional[Bool] = None, can_edit_profile_photo: Optional[Bool] = None, can_edit_username: Optional[Bool] = None, can_change_gift_settings: Optional[Bool] = None, can_view_gifts_and_stars: Optional[Bool] = None, can_convert_gifts_to_stars: Optional[Bool] = None, can_transfer_and_upgrade_gifts: Optional[Bool] = None, can_transfer_stars: Optional[Bool] = None, can_manage_stories: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.can_reply = can_reply
        self.can_read_messages = can_read_messages
        self.can_delete_sent_messages = can_delete_sent_messages
        self.can_delete_all_messages = can_delete_all_messages
        self.can_edit_name = can_edit_name
        self.can_edit_bio = can_edit_bio
        self.can_edit_profile_photo = can_edit_profile_photo
        self.can_edit_username = can_edit_username
        self.can_change_gift_settings = can_change_gift_settings
        self.can_view_gifts_and_stars = can_view_gifts_and_stars
        self.can_convert_gifts_to_stars = can_convert_gifts_to_stars
        self.can_transfer_and_upgrade_gifts = can_transfer_and_upgrade_gifts
        self.can_transfer_stars = can_transfer_stars
        self.can_manage_stories = can_manage_stories
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.can_reply = existing.can_reply
        self.can_read_messages = existing.can_read_messages
        self.can_delete_sent_messages = existing.can_delete_sent_messages
        self.can_delete_all_messages = existing.can_delete_all_messages
        self.can_edit_name = existing.can_edit_name
        self.can_edit_bio = existing.can_edit_bio
        self.can_edit_profile_photo = existing.can_edit_profile_photo
        self.can_edit_username = existing.can_edit_username
        self.can_change_gift_settings = existing.can_change_gift_settings
        self.can_view_gifts_and_stars = existing.can_view_gifts_and_stars
        self.can_convert_gifts_to_stars = existing.can_convert_gifts_to_stars
        self.can_transfer_and_upgrade_gifts = existing.can_transfer_and_upgrade_gifts
        self.can_transfer_stars = existing.can_transfer_stars
        self.can_manage_stories = existing.can_manage_stories
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.can_reply == other.can_reply and self.can_read_messages == other.can_read_messages and self.can_delete_sent_messages == other.can_delete_sent_messages and self.can_delete_all_messages == other.can_delete_all_messages and self.can_edit_name == other.can_edit_name and self.can_edit_bio == other.can_edit_bio and self.can_edit_profile_photo == other.can_edit_profile_photo and self.can_edit_username == other.can_edit_username and self.can_change_gift_settings == other.can_change_gift_settings and self.can_view_gifts_and_stars == other.can_view_gifts_and_stars and self.can_convert_gifts_to_stars == other.can_convert_gifts_to_stars and self.can_transfer_and_upgrade_gifts == other.can_transfer_and_upgrade_gifts and self.can_transfer_stars == other.can_transfer_stars and self.can_manage_stories == other.can_manage_stories

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.can_reply is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_reply.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_read_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_read_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_delete_sent_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_delete_sent_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_delete_all_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_delete_all_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_edit_name is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_edit_name.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_edit_bio is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_edit_bio.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_edit_profile_photo is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_edit_profile_photo.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_edit_username is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_edit_username.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_change_gift_settings is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_change_gift_settings.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_view_gifts_and_stars is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_view_gifts_and_stars.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_convert_gifts_to_stars is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_convert_gifts_to_stars.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_transfer_and_upgrade_gifts is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_transfer_and_upgrade_gifts.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_transfer_stars is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_transfer_stars.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_manage_stories is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_manage_stories.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.can_change_gift_settings is not None:
            result.set_boolean(result.root, "can_change_gift_settings", self.can_change_gift_settings.value())
        if self.can_convert_gifts_to_stars is not None:
            result.set_boolean(result.root, "can_convert_gifts_to_stars", self.can_convert_gifts_to_stars.value())
        if self.can_delete_all_messages is not None:
            result.set_boolean(result.root, "can_delete_all_messages", self.can_delete_all_messages.value())
        if self.can_delete_sent_messages is not None:
            result.set_boolean(result.root, "can_delete_sent_messages", self.can_delete_sent_messages.value())
        if self.can_edit_bio is not None:
            result.set_boolean(result.root, "can_edit_bio", self.can_edit_bio.value())
        if self.can_edit_name is not None:
            result.set_boolean(result.root, "can_edit_name", self.can_edit_name.value())
        if self.can_edit_profile_photo is not None:
            result.set_boolean(result.root, "can_edit_profile_photo", self.can_edit_profile_photo.value())
        if self.can_edit_username is not None:
            result.set_boolean(result.root, "can_edit_username", self.can_edit_username.value())
        if self.can_manage_stories is not None:
            result.set_boolean(result.root, "can_manage_stories", self.can_manage_stories.value())
        if self.can_read_messages is not None:
            result.set_boolean(result.root, "can_read_messages", self.can_read_messages.value())
        if self.can_reply is not None:
            result.set_boolean(result.root, "can_reply", self.can_reply.value())
        if self.can_transfer_and_upgrade_gifts is not None:
            result.set_boolean(result.root, "can_transfer_and_upgrade_gifts", self.can_transfer_and_upgrade_gifts.value())
        if self.can_transfer_stars is not None:
            result.set_boolean(result.root, "can_transfer_stars", self.can_transfer_stars.value())
        if self.can_view_gifts_and_stars is not None:
            result.set_boolean(result.root, "can_view_gifts_and_stars", self.can_view_gifts_and_stars.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BusinessBotRights:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("BusinessBotRights JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BusinessBotRights JSON value is not an object")
        var parsed_can_reply_index = data.object_get(data.root, "can_reply")
        var parsed_can_reply: Optional[Bool] = None
        if parsed_can_reply_index != -1 and not data.is_null(parsed_can_reply_index):
            parsed_can_reply = Optional[Bool](data.boolean_value(parsed_can_reply_index))
        var parsed_can_read_messages_index = data.object_get(data.root, "can_read_messages")
        var parsed_can_read_messages: Optional[Bool] = None
        if parsed_can_read_messages_index != -1 and not data.is_null(parsed_can_read_messages_index):
            parsed_can_read_messages = Optional[Bool](data.boolean_value(parsed_can_read_messages_index))
        var parsed_can_delete_sent_messages_index = data.object_get(data.root, "can_delete_sent_messages")
        var parsed_can_delete_sent_messages: Optional[Bool] = None
        if parsed_can_delete_sent_messages_index != -1 and not data.is_null(parsed_can_delete_sent_messages_index):
            parsed_can_delete_sent_messages = Optional[Bool](data.boolean_value(parsed_can_delete_sent_messages_index))
        var parsed_can_delete_all_messages_index = data.object_get(data.root, "can_delete_all_messages")
        var parsed_can_delete_all_messages: Optional[Bool] = None
        if parsed_can_delete_all_messages_index != -1 and not data.is_null(parsed_can_delete_all_messages_index):
            parsed_can_delete_all_messages = Optional[Bool](data.boolean_value(parsed_can_delete_all_messages_index))
        var parsed_can_edit_name_index = data.object_get(data.root, "can_edit_name")
        var parsed_can_edit_name: Optional[Bool] = None
        if parsed_can_edit_name_index != -1 and not data.is_null(parsed_can_edit_name_index):
            parsed_can_edit_name = Optional[Bool](data.boolean_value(parsed_can_edit_name_index))
        var parsed_can_edit_bio_index = data.object_get(data.root, "can_edit_bio")
        var parsed_can_edit_bio: Optional[Bool] = None
        if parsed_can_edit_bio_index != -1 and not data.is_null(parsed_can_edit_bio_index):
            parsed_can_edit_bio = Optional[Bool](data.boolean_value(parsed_can_edit_bio_index))
        var parsed_can_edit_profile_photo_index = data.object_get(data.root, "can_edit_profile_photo")
        var parsed_can_edit_profile_photo: Optional[Bool] = None
        if parsed_can_edit_profile_photo_index != -1 and not data.is_null(parsed_can_edit_profile_photo_index):
            parsed_can_edit_profile_photo = Optional[Bool](data.boolean_value(parsed_can_edit_profile_photo_index))
        var parsed_can_edit_username_index = data.object_get(data.root, "can_edit_username")
        var parsed_can_edit_username: Optional[Bool] = None
        if parsed_can_edit_username_index != -1 and not data.is_null(parsed_can_edit_username_index):
            parsed_can_edit_username = Optional[Bool](data.boolean_value(parsed_can_edit_username_index))
        var parsed_can_change_gift_settings_index = data.object_get(data.root, "can_change_gift_settings")
        var parsed_can_change_gift_settings: Optional[Bool] = None
        if parsed_can_change_gift_settings_index != -1 and not data.is_null(parsed_can_change_gift_settings_index):
            parsed_can_change_gift_settings = Optional[Bool](data.boolean_value(parsed_can_change_gift_settings_index))
        var parsed_can_view_gifts_and_stars_index = data.object_get(data.root, "can_view_gifts_and_stars")
        var parsed_can_view_gifts_and_stars: Optional[Bool] = None
        if parsed_can_view_gifts_and_stars_index != -1 and not data.is_null(parsed_can_view_gifts_and_stars_index):
            parsed_can_view_gifts_and_stars = Optional[Bool](data.boolean_value(parsed_can_view_gifts_and_stars_index))
        var parsed_can_convert_gifts_to_stars_index = data.object_get(data.root, "can_convert_gifts_to_stars")
        var parsed_can_convert_gifts_to_stars: Optional[Bool] = None
        if parsed_can_convert_gifts_to_stars_index != -1 and not data.is_null(parsed_can_convert_gifts_to_stars_index):
            parsed_can_convert_gifts_to_stars = Optional[Bool](data.boolean_value(parsed_can_convert_gifts_to_stars_index))
        var parsed_can_transfer_and_upgrade_gifts_index = data.object_get(data.root, "can_transfer_and_upgrade_gifts")
        var parsed_can_transfer_and_upgrade_gifts: Optional[Bool] = None
        if parsed_can_transfer_and_upgrade_gifts_index != -1 and not data.is_null(parsed_can_transfer_and_upgrade_gifts_index):
            parsed_can_transfer_and_upgrade_gifts = Optional[Bool](data.boolean_value(parsed_can_transfer_and_upgrade_gifts_index))
        var parsed_can_transfer_stars_index = data.object_get(data.root, "can_transfer_stars")
        var parsed_can_transfer_stars: Optional[Bool] = None
        if parsed_can_transfer_stars_index != -1 and not data.is_null(parsed_can_transfer_stars_index):
            parsed_can_transfer_stars = Optional[Bool](data.boolean_value(parsed_can_transfer_stars_index))
        var parsed_can_manage_stories_index = data.object_get(data.root, "can_manage_stories")
        var parsed_can_manage_stories: Optional[Bool] = None
        if parsed_can_manage_stories_index != -1 and not data.is_null(parsed_can_manage_stories_index):
            parsed_can_manage_stories = Optional[Bool](data.boolean_value(parsed_can_manage_stories_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "can_reply" and key != "can_read_messages" and key != "can_delete_sent_messages" and key != "can_delete_all_messages" and key != "can_edit_name" and key != "can_edit_bio" and key != "can_edit_profile_photo" and key != "can_edit_username" and key != "can_change_gift_settings" and key != "can_view_gifts_and_stars" and key != "can_convert_gifts_to_stars" and key != "can_transfer_and_upgrade_gifts" and key != "can_transfer_stars" and key != "can_manage_stories":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return BusinessBotRights(parsed_can_reply, parsed_can_read_messages, parsed_can_delete_sent_messages, parsed_can_delete_all_messages, parsed_can_edit_name, parsed_can_edit_bio, parsed_can_edit_profile_photo, parsed_can_edit_username, parsed_can_change_gift_settings, parsed_can_view_gifts_and_stars, parsed_can_convert_gifts_to_stars, parsed_can_transfer_and_upgrade_gifts, parsed_can_transfer_stars, parsed_can_manage_stories, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[BusinessBotRights]:
        var items = data.array_documents(array_index)
        var result = List[BusinessBotRights]()
        for index in range(len(items)):
            result.append(BusinessBotRights.de_json(items[index].copy()))
        return result^


struct BusinessConnection(Equatable, Hashable, Copyable, TelegramJsonObject):
    """The connection between a bot and a Telegram Business account."""

    var id: String
    var user: User
    var user_chat_id: Int
    var date: TimestampDateTime
    var is_enabled: Bool
    var rights: Optional[BusinessBotRights]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: String,
        user: User,
        user_chat_id: Int,
        date: TimestampDateTime,
        is_enabled: Bool,
        rights: Optional[BusinessBotRights] = None,
    ):
        self.id = id.copy()
        self.user = user.copy()
        self.user_chat_id = user_chat_id
        self.date = date.copy()
        self.is_enabled = is_enabled
        self.rights = rights.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: String,
        user: User,
        user_chat_id: Int,
        date: TimestampDateTime,
        is_enabled: Bool,
        rights: Optional[BusinessBotRights] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id.copy()
        self.user = user.copy()
        self.user_chat_id = user_chat_id
        self.date = date.copy()
        self.is_enabled = is_enabled
        self.rights = rights.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id.copy()
        self.user = existing.user.copy()
        self.user_chat_id = existing.user_chat_id
        self.date = existing.date.copy()
        self.is_enabled = existing.is_enabled
        self.rights = existing.rights.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.id == other.id
            and self.user == other.user
            and self.user_chat_id == other.user_chat_id
            and self.date == other.date
            and self.rights == other.rights
            and self.is_enabled == other.is_enabled
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.id.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "id", self.id)
        result.set_number(result.root, "user_chat_id", String(self.user_chat_id))
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        result.set_boolean(result.root, "is_enabled", self.is_enabled)
        var user_data = self.user.to_dict(recursive=recursive)
        var user_index = result.copy_subtree_from(user_data, user_data.root)
        result.object_set(result.root, "user", user_index)
        if self.rights is not None:
            var rights_data = self.rights.value().to_dict(recursive=recursive)
            var rights_index = result.copy_subtree_from(rights_data, rights_data.root)
            result.object_set(result.root, "rights", rights_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BusinessConnection:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BusinessConnection JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var user_index = data.object_get(data.root, "user")
        var user_chat_id_index = data.object_get(data.root, "user_chat_id")
        var date_index = data.object_get(data.root, "date")
        var enabled_index = data.object_get(data.root, "is_enabled")
        if id_index == -1 or user_index == -1 or user_chat_id_index == -1 or date_index == -1 or enabled_index == -1:
            raise Error("BusinessConnection JSON object is missing a required field")
        var rights: Optional[BusinessBotRights] = None
        var rights_index = data.object_get(data.root, "rights")
        if rights_index != -1 and not data.is_null(rights_index):
            rights = Optional[BusinessBotRights](BusinessBotRights.de_json(_business_nested(data, rights_index)))
        var known = List[String]()
        known.append("id")
        known.append("user")
        known.append("user_chat_id")
        known.append("date")
        known.append("is_enabled")
        known.append("rights")
        return BusinessConnection(
            data.string_value(id_index),
            User.de_json(_business_nested(data, user_index)),
            data.integer_value(user_chat_id_index),
            from_timestamp(data.integer_value(date_index)),
            data.boolean_value(enabled_index),
            rights,
            api_kwargs=_business_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[BusinessConnection]:
        var items = data.array_documents(array_index)
        var result = List[BusinessConnection]()
        for item in items:
            result.append(BusinessConnection.de_json(item.copy()))
        return result^


struct BusinessMessagesDeleted(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Deleted message IDs from a connected business account."""

    var business_connection_id: String
    var chat: Chat
    var message_ids: List[Int]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        business_connection_id: String,
        chat: Chat,
        message_ids: List[Int],
    ):
        self.business_connection_id = business_connection_id.copy()
        self.chat = chat.copy()
        self.message_ids = message_ids.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        business_connection_id: String,
        chat: Chat,
        message_ids: List[Int],
        *,
        api_kwargs: JsonDocument,
    ):
        self.business_connection_id = business_connection_id.copy()
        self.chat = chat.copy()
        self.message_ids = message_ids.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.business_connection_id = existing.business_connection_id.copy()
        self.chat = existing.chat.copy()
        self.message_ids = existing.message_ids.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.business_connection_id != other.business_connection_id or self.chat != other.chat:
            return False
        if len(self.message_ids) != len(other.message_ids):
            return False
        for index in range(len(self.message_ids)):
            if self.message_ids[index] != other.message_ids[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.business_connection_id.as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.chat)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "business_connection_id", self.business_connection_id)
        var chat_data = self.chat.to_dict(recursive=recursive)
        var chat_index = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_index)
        var ids = result.add_array()
        for message_id in self.message_ids:
            var id_node = result.add_number(String(message_id))
            result.append_child(ids, id_node)
        result.object_set(result.root, "message_ids", ids)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BusinessMessagesDeleted:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BusinessMessagesDeleted JSON value must be an object")
        var connection_index = data.object_get(data.root, "business_connection_id")
        var chat_index = data.object_get(data.root, "chat")
        var ids_index = data.object_get(data.root, "message_ids")
        if connection_index == -1 or chat_index == -1 or ids_index == -1:
            raise Error("BusinessMessagesDeleted JSON object is missing a required field")
        var known = List[String]()
        known.append("business_connection_id")
        known.append("chat")
        known.append("message_ids")
        return BusinessMessagesDeleted(
            data.string_value(connection_index),
            Chat.de_json(_business_nested(data, chat_index)),
            _business_int_list(data, ids_index),
            api_kwargs=_business_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[BusinessMessagesDeleted]:
        var items = data.array_documents(array_index)
        var result = List[BusinessMessagesDeleted]()
        for item in items:
            result.append(BusinessMessagesDeleted.de_json(item.copy()))
        return result^


struct BusinessIntro(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Telegram Business start-page title, message, and optional sticker."""

    var title: Optional[String]
    var message: Optional[String]
    var sticker: Optional[Sticker]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        title: Optional[String] = None,
        message: Optional[String] = None,
        sticker: Optional[Sticker] = None,
    ):
        self.title = title.copy()
        self.message = message.copy()
        self.sticker = sticker.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: Optional[String] = None,
        message: Optional[String] = None,
        sticker: Optional[Sticker] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.title = title.copy()
        self.message = message.copy()
        self.sticker = sticker.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.title = existing.title.copy()
        self.message = existing.message.copy()
        self.sticker = existing.sticker.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.title == other.title and self.message == other.message and self.sticker == other.sticker

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("BusinessIntro\0").as_bytes())
        if self.title is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(self.title.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.message is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(self.message.value().as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.sticker is None:
            hasher.update(String("None").as_bytes())
        else:
            hasher.update(String(hash(self.sticker.value())).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.title is not None:
            result.set_string(result.root, "title", self.title.value())
        if self.message is not None:
            result.set_string(result.root, "message", self.message.value())
        if self.sticker is not None:
            var sticker_data = self.sticker.value().to_dict(recursive=recursive)
            var sticker_index = result.copy_subtree_from(sticker_data, sticker_data.root)
            result.object_set(result.root, "sticker", sticker_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BusinessIntro:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BusinessIntro JSON value must be an object")
        var title: Optional[String] = None
        var title_index = data.object_get(data.root, "title")
        if title_index != -1 and not data.is_null(title_index):
            title = Optional[String](data.string_value(title_index))
        var message: Optional[String] = None
        var message_index = data.object_get(data.root, "message")
        if message_index != -1 and not data.is_null(message_index):
            message = Optional[String](data.string_value(message_index))
        var sticker: Optional[Sticker] = None
        var sticker_index = data.object_get(data.root, "sticker")
        if sticker_index != -1 and not data.is_null(sticker_index):
            sticker = Optional[Sticker](Sticker.de_json(_business_nested(data, sticker_index)))
        var known = List[String]()
        known.append("title")
        known.append("message")
        known.append("sticker")
        return BusinessIntro(
            title,
            message,
            sticker,
            api_kwargs=_business_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[BusinessIntro]:
        var items = data.array_documents(array_index)
        var result = List[BusinessIntro]()
        for item in items:
            result.append(BusinessIntro.de_json(item.copy()))
        return result^


struct BusinessLocation(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Telegram Business address and optional map location."""

    var address: String
    var location: Optional[Location]
    var api_kwargs: JsonDocument

    def __init__(out self, address: String, location: Optional[Location] = None):
        self.address = address.copy()
        self.location = location.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        address: String,
        location: Optional[Location] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.address = address.copy()
        self.location = location.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.address = existing.address.copy()
        self.location = existing.location.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        # Upstream identity intentionally ignores the optional map coordinates.
        return self.address == other.address

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.address.as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "address", self.address)
        if self.location is not None:
            var location_data = self.location.value().to_dict(recursive=recursive)
            var location_index = result.copy_subtree_from(location_data, location_data.root)
            result.object_set(result.root, "location", location_index)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BusinessLocation:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BusinessLocation JSON value must be an object")
        var address_index = data.object_get(data.root, "address")
        if address_index == -1:
            raise Error("BusinessLocation JSON object is missing required address")
        var location: Optional[Location] = None
        var location_index = data.object_get(data.root, "location")
        if location_index != -1 and not data.is_null(location_index):
            location = Optional[Location](Location.de_json(_business_nested(data, location_index)))
        var known = List[String]()
        known.append("address")
        known.append("location")
        return BusinessLocation(
            data.string_value(address_index),
            location,
            api_kwargs=_business_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[BusinessLocation]:
        var items = data.array_documents(array_index)
        var result = List[BusinessLocation]()
        for item in items:
            result.append(BusinessLocation.de_json(item.copy()))
        return result^


struct BusinessOpeningHours(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Timezone name and weekly opening intervals for a business account."""

    var time_zone_name: String
    var opening_hours: List[BusinessOpeningHoursInterval]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        time_zone_name: String,
        opening_hours: List[BusinessOpeningHoursInterval],
    ):
        self.time_zone_name = time_zone_name.copy()
        self.opening_hours = opening_hours.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        time_zone_name: String,
        opening_hours: List[BusinessOpeningHoursInterval],
        *,
        api_kwargs: JsonDocument,
    ):
        self.time_zone_name = time_zone_name.copy()
        self.opening_hours = opening_hours.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.time_zone_name = existing.time_zone_name.copy()
        self.opening_hours = existing.opening_hours.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.time_zone_name != other.time_zone_name or len(self.opening_hours) != len(other.opening_hours):
            return False
        for index in range(len(self.opening_hours)):
            if self.opening_hours[index] != other.opening_hours[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.time_zone_name.as_bytes())
        hasher.update(String("\0").as_bytes())
        for interval in self.opening_hours:
            hasher.update(String(hash(interval)).as_bytes())
            hasher.update(String("\0").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "time_zone_name", self.time_zone_name)
        var interval_array = result.add_array()
        for interval in self.opening_hours:
            var interval_data = interval.to_dict(recursive=recursive)
            var interval_index = result.copy_subtree_from(interval_data, interval_data.root)
            result.append_child(interval_array, interval_index)
        result.object_set(result.root, "opening_hours", interval_array)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> BusinessOpeningHours:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("BusinessOpeningHours JSON value must be an object")
        var zone_index = data.object_get(data.root, "time_zone_name")
        if zone_index == -1:
            raise Error("BusinessOpeningHours JSON object is missing time_zone_name")
        var intervals = List[BusinessOpeningHoursInterval]()
        var intervals_index = data.object_get(data.root, "opening_hours")
        if intervals_index != -1 and not data.is_null(intervals_index):
            if data.nodes[intervals_index].kind != JSON_ARRAY:
                raise Error("BusinessOpeningHours opening_hours must be a JSON array")
            var child = data.nodes[intervals_index].first_child
            while child != -1:
                intervals.append(
                    BusinessOpeningHoursInterval.de_json(_business_nested(data, child))
                )
                child = data.nodes[child].next_sibling
        var known = List[String]()
        known.append("time_zone_name")
        known.append("opening_hours")
        return BusinessOpeningHours(
            data.string_value(zone_index),
            intervals^,
            api_kwargs=_business_unknown_fields(data, known),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[BusinessOpeningHours]:
        var items = data.array_documents(array_index)
        var result = List[BusinessOpeningHours]()
        for item in items:
            result.append(BusinessOpeningHours.de_json(item.copy()))
        return result^
