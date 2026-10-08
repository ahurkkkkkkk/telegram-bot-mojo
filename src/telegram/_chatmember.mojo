#!/usr/bin/env mojo
#
# Native tagged data-model translation of python-telegram-bot v22.8 _chatmember.py.
# LGPL-3.0-or-later; see LICENSE.

"""Chat-member status and forward-compatible status-specific JSON fields."""

from std.collections import List
from std.hashlib.hasher import Hasher
from std.collections.optional import Optional

from telegram._user import User
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_OBJECT, JSON_STRING, JSON_NULL, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _chatmember_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _chatmember_field_known(status: String, key: String) -> Bool:
    if status == "creator":
        return key == "is_anonymous" or key == "custom_title"
    if status == "administrator":
        return (
            key == "can_be_edited" or key == "is_anonymous" or key == "can_manage_chat"
            or key == "can_delete_messages" or key == "can_manage_video_chats"
            or key == "can_restrict_members" or key == "can_promote_members"
            or key == "can_change_info" or key == "can_invite_users"
            or key == "can_post_messages" or key == "can_edit_messages"
            or key == "can_pin_messages" or key == "can_post_stories"
            or key == "can_edit_stories" or key == "can_delete_stories"
            or key == "can_manage_topics" or key == "custom_title"
            or key == "can_manage_direct_messages" or key == "can_manage_tags"
        )
    if status == "member":
        return key == "until_date" or key == "tag"
    if status == "restricted":
        return (
            key == "is_member" or key == "can_change_info" or key == "can_invite_users"
            or key == "can_pin_messages" or key == "can_send_messages"
            or key == "can_send_polls" or key == "can_send_other_messages"
            or key == "can_add_web_page_previews" or key == "can_manage_topics"
            or key == "until_date" or key == "can_send_audios"
            or key == "can_send_documents" or key == "can_send_photos"
            or key == "can_send_videos" or key == "can_send_video_notes"
            or key == "can_send_voice_notes" or key == "can_edit_tag"
            or key == "can_react_to_messages" or key == "tag"
        )
    if status == "kicked":
        return key == "until_date"
    return False


def _chatmember_required_fields(status: String) -> List[String]:
    var result = List[String]()
    if status == "creator":
        result.append("is_anonymous")
    elif status == "administrator":
        result.append("can_be_edited")
        result.append("is_anonymous")
        result.append("can_manage_chat")
        result.append("can_delete_messages")
        result.append("can_manage_video_chats")
        result.append("can_restrict_members")
        result.append("can_promote_members")
        result.append("can_change_info")
        result.append("can_invite_users")
        result.append("can_post_stories")
        result.append("can_edit_stories")
        result.append("can_delete_stories")
    elif status == "restricted":
        result.append("is_member")
        result.append("can_change_info")
        result.append("can_invite_users")
        result.append("can_pin_messages")
        result.append("can_send_messages")
        result.append("can_send_polls")
        result.append("can_send_other_messages")
        result.append("can_add_web_page_previews")
        result.append("can_manage_topics")
        result.append("until_date")
        result.append("can_send_audios")
        result.append("can_send_documents")
        result.append("can_send_photos")
        result.append("can_send_videos")
        result.append("can_send_video_notes")
        result.append("can_send_voice_notes")
        result.append("can_edit_tag")
        result.append("can_react_to_messages")
    elif status == "kicked":
        result.append("until_date")
    return result^


struct ChatMember(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native tagged chat-member value; status-specific values stay in a JSON object.

    ``field_json`` and the typed optional accessors expose every current or future
    status attribute without requiring a Python inheritance hierarchy.
    """

    comptime ADMINISTRATOR = "administrator"
    comptime OWNER = "creator"
    comptime BANNED = "kicked"
    comptime LEFT = "left"
    comptime MEMBER = "member"
    comptime RESTRICTED = "restricted"

    var user: User
    var status: String
    var attributes: JsonDocument
    var api_kwargs: JsonDocument

    def __init__(out self, user: User, status: String):
        self.user = user.copy()
        self.status = status.copy()
        self.attributes = empty_json_object()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self, user: User, status: String, attributes: JsonDocument,
        api_kwargs: JsonDocument,
    ):
        self.user = user.copy()
        self.status = status.copy()
        self.attributes = attributes.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.user = existing.user.copy()
        self.status = existing.status.copy()
        self.attributes = existing.attributes.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.user == other.user and self.status == other.status

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.user.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(self.status.as_bytes())

    @staticmethod
    def owner(
        user: User, is_anonymous: Bool, custom_title: Optional[String] = None
    ) raises -> Self:
        var attributes = empty_json_object()
        attributes.set_boolean(attributes.root, "is_anonymous", is_anonymous)
        if custom_title is not None:
            attributes.set_string(attributes.root, "custom_title", custom_title.value())
        return Self(user, Self.OWNER, attributes, empty_json_object())

    @staticmethod
    def administrator(
        user: User,
        can_be_edited: Bool,
        is_anonymous: Bool,
        can_manage_chat: Bool,
        can_delete_messages: Bool,
        can_manage_video_chats: Bool,
        can_restrict_members: Bool,
        can_promote_members: Bool,
        can_change_info: Bool,
        can_invite_users: Bool,
        can_post_stories: Bool,
        can_edit_stories: Bool,
        can_delete_stories: Bool,
        can_post_messages: Optional[Bool] = None,
        can_edit_messages: Optional[Bool] = None,
        can_pin_messages: Optional[Bool] = None,
        can_manage_topics: Optional[Bool] = None,
        custom_title: Optional[String] = None,
        can_manage_direct_messages: Optional[Bool] = None,
        can_manage_tags: Optional[Bool] = None,
    ) raises -> Self:
        var attributes = empty_json_object()
        attributes.set_boolean(attributes.root, "can_be_edited", can_be_edited)
        attributes.set_boolean(attributes.root, "is_anonymous", is_anonymous)
        attributes.set_boolean(attributes.root, "can_manage_chat", can_manage_chat)
        attributes.set_boolean(attributes.root, "can_delete_messages", can_delete_messages)
        attributes.set_boolean(attributes.root, "can_manage_video_chats", can_manage_video_chats)
        attributes.set_boolean(attributes.root, "can_restrict_members", can_restrict_members)
        attributes.set_boolean(attributes.root, "can_promote_members", can_promote_members)
        attributes.set_boolean(attributes.root, "can_change_info", can_change_info)
        attributes.set_boolean(attributes.root, "can_invite_users", can_invite_users)
        attributes.set_boolean(attributes.root, "can_post_stories", can_post_stories)
        attributes.set_boolean(attributes.root, "can_edit_stories", can_edit_stories)
        attributes.set_boolean(attributes.root, "can_delete_stories", can_delete_stories)
        if can_post_messages is not None:
            attributes.set_boolean(attributes.root, "can_post_messages", can_post_messages.value())
        if can_edit_messages is not None:
            attributes.set_boolean(attributes.root, "can_edit_messages", can_edit_messages.value())
        if can_pin_messages is not None:
            attributes.set_boolean(attributes.root, "can_pin_messages", can_pin_messages.value())
        if can_manage_topics is not None:
            attributes.set_boolean(attributes.root, "can_manage_topics", can_manage_topics.value())
        if custom_title is not None:
            attributes.set_string(attributes.root, "custom_title", custom_title.value())
        if can_manage_direct_messages is not None:
            attributes.set_boolean(
                attributes.root, "can_manage_direct_messages",
                can_manage_direct_messages.value(),
            )
        if can_manage_tags is not None:
            attributes.set_boolean(attributes.root, "can_manage_tags", can_manage_tags.value())
        return Self(user, Self.ADMINISTRATOR, attributes, empty_json_object())

    @staticmethod
    def member(
        user: User,
        until_date: Optional[TimestampDateTime] = None,
        tag: Optional[String] = None,
    ) raises -> Self:
        var attributes = empty_json_object()
        if until_date is not None:
            attributes.set_number(
                attributes.root, "until_date", String(to_timestamp(until_date.value()))
            )
        if tag is not None:
            attributes.set_string(attributes.root, "tag", tag.value())
        return Self(user, Self.MEMBER, attributes, empty_json_object())

    @staticmethod
    def restricted(
        user: User,
        is_member: Bool,
        can_change_info: Bool,
        can_invite_users: Bool,
        can_pin_messages: Bool,
        can_send_messages: Bool,
        can_send_polls: Bool,
        can_send_other_messages: Bool,
        can_add_web_page_previews: Bool,
        can_manage_topics: Bool,
        until_date: TimestampDateTime,
        can_send_audios: Bool,
        can_send_documents: Bool,
        can_send_photos: Bool,
        can_send_videos: Bool,
        can_send_video_notes: Bool,
        can_send_voice_notes: Bool,
        can_edit_tag: Bool,
        can_react_to_messages: Bool,
        tag: Optional[String] = None,
    ) raises -> Self:
        var attributes = empty_json_object()
        attributes.set_boolean(attributes.root, "is_member", is_member)
        attributes.set_boolean(attributes.root, "can_change_info", can_change_info)
        attributes.set_boolean(attributes.root, "can_invite_users", can_invite_users)
        attributes.set_boolean(attributes.root, "can_pin_messages", can_pin_messages)
        attributes.set_boolean(attributes.root, "can_send_messages", can_send_messages)
        attributes.set_boolean(attributes.root, "can_send_polls", can_send_polls)
        attributes.set_boolean(attributes.root, "can_send_other_messages", can_send_other_messages)
        attributes.set_boolean(attributes.root, "can_add_web_page_previews", can_add_web_page_previews)
        attributes.set_boolean(attributes.root, "can_manage_topics", can_manage_topics)
        attributes.set_number(attributes.root, "until_date", String(to_timestamp(until_date)))
        attributes.set_boolean(attributes.root, "can_send_audios", can_send_audios)
        attributes.set_boolean(attributes.root, "can_send_documents", can_send_documents)
        attributes.set_boolean(attributes.root, "can_send_photos", can_send_photos)
        attributes.set_boolean(attributes.root, "can_send_videos", can_send_videos)
        attributes.set_boolean(attributes.root, "can_send_video_notes", can_send_video_notes)
        attributes.set_boolean(attributes.root, "can_send_voice_notes", can_send_voice_notes)
        attributes.set_boolean(attributes.root, "can_edit_tag", can_edit_tag)
        attributes.set_boolean(attributes.root, "can_react_to_messages", can_react_to_messages)
        if tag is not None:
            attributes.set_string(attributes.root, "tag", tag.value())
        return Self(user, Self.RESTRICTED, attributes, empty_json_object())

    @staticmethod
    def left(user: User) raises -> Self:
        return Self(user, Self.LEFT)

    @staticmethod
    def banned(user: User, until_date: TimestampDateTime) raises -> Self:
        var attributes = empty_json_object()
        attributes.set_number(attributes.root, "until_date", String(to_timestamp(until_date)))
        return Self(user, Self.BANNED, attributes, empty_json_object())

    def has_field(self, key: String) raises -> Bool:
        return self.attributes.object_get(self.attributes.root, key) != -1

    def field_json(self, key: String) raises -> JsonDocument:
        var index = self.attributes.object_get(self.attributes.root, key)
        if index == -1:
            raise Error(String("ChatMember has no status field: ", key))
        return _chatmember_nested(self.attributes, index)

    def optional_boolean_field(self, key: String) raises -> Optional[Bool]:
        var index = self.attributes.object_get(self.attributes.root, key)
        if index == -1 or self.attributes.is_null(index):
            return None
        return Optional[Bool](self.attributes.boolean_value(index))

    def optional_integer_field(self, key: String) raises -> Optional[Int]:
        var index = self.attributes.object_get(self.attributes.root, key)
        if index == -1 or self.attributes.is_null(index):
            return None
        return Optional[Int](self.attributes.integer_value(index))

    def optional_string_field(self, key: String) raises -> Optional[String]:
        var index = self.attributes.object_get(self.attributes.root, key)
        if index == -1 or self.attributes.is_null(index):
            return None
        return Optional[String](self.attributes.string_value(index))

    def until_date_value(self) raises -> Optional[TimestampDateTime]:
        var index = self.attributes.object_get(self.attributes.root, "until_date")
        if index == -1 or self.attributes.is_null(index):
            return None
        return Optional[TimestampDateTime](from_timestamp(self.attributes.integer_value(index)))

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "status", self.status)
        var user_data = self.user.to_dict(recursive)
        var user_node = result.copy_subtree_from(user_data, user_data.root)
        result.object_set(result.root, "user", user_node)
        var child = self.attributes.nodes[self.attributes.root].first_child
        while child != -1:
            if self.attributes.nodes[child].kind != JSON_NULL:
                var copied = result.copy_subtree_from(self.attributes, child)
                result.object_set(result.root, self.attributes.nodes[child].name.copy(), copied)
            child = self.attributes.nodes[child].next_sibling
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatMember JSON value must be an object")
        var status_index = data.object_get(data.root, "status")
        var user_index = data.object_get(data.root, "user")
        if status_index == -1 or user_index == -1:
            raise Error("ChatMember JSON object is missing status or user")
        if data.nodes[status_index].kind != JSON_STRING:
            raise Error("ChatMember status must be a string")
        var status = data.string_value(status_index)
        var user = User.de_json(_chatmember_nested(data, user_index))
        var required_fields = _chatmember_required_fields(status)
        for key in required_fields:
            var required_index = data.object_get(data.root, key)
            if required_index == -1:
                raise Error(String("ChatMember JSON object is missing required field: ", key))
        if status == "restricted":
            var can_react_index = data.object_get(data.root, "can_react_to_messages")
            if can_react_index == -1 or data.is_null(can_react_index):
                raise Error("ChatMember restricted status requires can_react_to_messages")
        var attributes = empty_json_object()
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "status" and key != "user":
                if _chatmember_field_known(status, key):
                    var copied = attributes.copy_subtree_from(data, child)
                    attributes.object_set(attributes.root, key.copy(), copied)
                else:
                    # Telegram still sends this deprecated restricted-member field;
                    # upstream deliberately preserves it in api_kwargs.
                    var copied = api_kwargs.copy_subtree_from(data, child)
                    api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(user, status, attributes, api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^
