#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _chatadministratorrights.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct ChatAdministratorRights(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream ChatAdministratorRights."""

    var is_anonymous: Bool
    var can_manage_chat: Bool
    var can_delete_messages: Bool
    var can_manage_video_chats: Bool
    var can_restrict_members: Bool
    var can_promote_members: Bool
    var can_change_info: Bool
    var can_invite_users: Bool
    var can_post_stories: Bool
    var can_edit_stories: Bool
    var can_delete_stories: Bool
    var can_post_messages: Optional[Bool]
    var can_edit_messages: Optional[Bool]
    var can_pin_messages: Optional[Bool]
    var can_manage_topics: Optional[Bool]
    var can_manage_direct_messages: Optional[Bool]
    var can_manage_tags: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, is_anonymous: Bool, can_manage_chat: Bool, can_delete_messages: Bool, can_manage_video_chats: Bool, can_restrict_members: Bool, can_promote_members: Bool, can_change_info: Bool, can_invite_users: Bool, can_post_stories: Bool, can_edit_stories: Bool, can_delete_stories: Bool, can_post_messages: Optional[Bool] = None, can_edit_messages: Optional[Bool] = None, can_pin_messages: Optional[Bool] = None, can_manage_topics: Optional[Bool] = None, can_manage_direct_messages: Optional[Bool] = None, can_manage_tags: Optional[Bool] = None):
        self.is_anonymous = is_anonymous
        self.can_manage_chat = can_manage_chat
        self.can_delete_messages = can_delete_messages
        self.can_manage_video_chats = can_manage_video_chats
        self.can_restrict_members = can_restrict_members
        self.can_promote_members = can_promote_members
        self.can_change_info = can_change_info
        self.can_invite_users = can_invite_users
        self.can_post_stories = can_post_stories
        self.can_edit_stories = can_edit_stories
        self.can_delete_stories = can_delete_stories
        self.can_post_messages = can_post_messages
        self.can_edit_messages = can_edit_messages
        self.can_pin_messages = can_pin_messages
        self.can_manage_topics = can_manage_topics
        self.can_manage_direct_messages = can_manage_direct_messages
        self.can_manage_tags = can_manage_tags
        self.api_kwargs = empty_json_object()

    def __init__(out self, is_anonymous: Bool, can_manage_chat: Bool, can_delete_messages: Bool, can_manage_video_chats: Bool, can_restrict_members: Bool, can_promote_members: Bool, can_change_info: Bool, can_invite_users: Bool, can_post_stories: Bool, can_edit_stories: Bool, can_delete_stories: Bool, can_post_messages: Optional[Bool] = None, can_edit_messages: Optional[Bool] = None, can_pin_messages: Optional[Bool] = None, can_manage_topics: Optional[Bool] = None, can_manage_direct_messages: Optional[Bool] = None, can_manage_tags: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.is_anonymous = is_anonymous
        self.can_manage_chat = can_manage_chat
        self.can_delete_messages = can_delete_messages
        self.can_manage_video_chats = can_manage_video_chats
        self.can_restrict_members = can_restrict_members
        self.can_promote_members = can_promote_members
        self.can_change_info = can_change_info
        self.can_invite_users = can_invite_users
        self.can_post_stories = can_post_stories
        self.can_edit_stories = can_edit_stories
        self.can_delete_stories = can_delete_stories
        self.can_post_messages = can_post_messages
        self.can_edit_messages = can_edit_messages
        self.can_pin_messages = can_pin_messages
        self.can_manage_topics = can_manage_topics
        self.can_manage_direct_messages = can_manage_direct_messages
        self.can_manage_tags = can_manage_tags
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.is_anonymous = existing.is_anonymous
        self.can_manage_chat = existing.can_manage_chat
        self.can_delete_messages = existing.can_delete_messages
        self.can_manage_video_chats = existing.can_manage_video_chats
        self.can_restrict_members = existing.can_restrict_members
        self.can_promote_members = existing.can_promote_members
        self.can_change_info = existing.can_change_info
        self.can_invite_users = existing.can_invite_users
        self.can_post_stories = existing.can_post_stories
        self.can_edit_stories = existing.can_edit_stories
        self.can_delete_stories = existing.can_delete_stories
        self.can_post_messages = existing.can_post_messages
        self.can_edit_messages = existing.can_edit_messages
        self.can_pin_messages = existing.can_pin_messages
        self.can_manage_topics = existing.can_manage_topics
        self.can_manage_direct_messages = existing.can_manage_direct_messages
        self.can_manage_tags = existing.can_manage_tags
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.is_anonymous == other.is_anonymous and self.can_manage_chat == other.can_manage_chat and self.can_delete_messages == other.can_delete_messages and self.can_manage_video_chats == other.can_manage_video_chats and self.can_restrict_members == other.can_restrict_members and self.can_promote_members == other.can_promote_members and self.can_change_info == other.can_change_info and self.can_invite_users == other.can_invite_users and self.can_post_messages == other.can_post_messages and self.can_edit_messages == other.can_edit_messages and self.can_pin_messages == other.can_pin_messages and self.can_manage_topics == other.can_manage_topics and self.can_post_stories == other.can_post_stories and self.can_edit_stories == other.can_edit_stories and self.can_delete_stories == other.can_delete_stories and self.can_manage_direct_messages == other.can_manage_direct_messages and self.can_manage_tags == other.can_manage_tags

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.is_anonymous:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_manage_chat:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_delete_messages:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_manage_video_chats:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_restrict_members:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_promote_members:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_change_info:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_invite_users:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_post_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_post_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_edit_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_edit_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_pin_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_pin_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_manage_topics is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_manage_topics.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_post_stories:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_edit_stories:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_delete_stories:
            hasher.update(String("true").as_bytes())
        else:
            hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_manage_direct_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_manage_direct_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_manage_tags is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_manage_tags.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_boolean(result.root, "can_change_info", self.can_change_info)
        result.set_boolean(result.root, "can_delete_messages", self.can_delete_messages)
        result.set_boolean(result.root, "can_delete_stories", self.can_delete_stories)
        if self.can_edit_messages is not None:
            result.set_boolean(result.root, "can_edit_messages", self.can_edit_messages.value())
        result.set_boolean(result.root, "can_edit_stories", self.can_edit_stories)
        result.set_boolean(result.root, "can_invite_users", self.can_invite_users)
        result.set_boolean(result.root, "can_manage_chat", self.can_manage_chat)
        if self.can_manage_direct_messages is not None:
            result.set_boolean(result.root, "can_manage_direct_messages", self.can_manage_direct_messages.value())
        if self.can_manage_tags is not None:
            result.set_boolean(result.root, "can_manage_tags", self.can_manage_tags.value())
        if self.can_manage_topics is not None:
            result.set_boolean(result.root, "can_manage_topics", self.can_manage_topics.value())
        result.set_boolean(result.root, "can_manage_video_chats", self.can_manage_video_chats)
        if self.can_pin_messages is not None:
            result.set_boolean(result.root, "can_pin_messages", self.can_pin_messages.value())
        if self.can_post_messages is not None:
            result.set_boolean(result.root, "can_post_messages", self.can_post_messages.value())
        result.set_boolean(result.root, "can_post_stories", self.can_post_stories)
        result.set_boolean(result.root, "can_promote_members", self.can_promote_members)
        result.set_boolean(result.root, "can_restrict_members", self.can_restrict_members)
        result.set_boolean(result.root, "is_anonymous", self.is_anonymous)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatAdministratorRights:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ChatAdministratorRights JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatAdministratorRights JSON value is not an object")
        var parsed_is_anonymous_index = data.object_get(data.root, "is_anonymous")
        if parsed_is_anonymous_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing is_anonymous")
        var parsed_is_anonymous = data.boolean_value(parsed_is_anonymous_index)
        var parsed_can_manage_chat_index = data.object_get(data.root, "can_manage_chat")
        if parsed_can_manage_chat_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_manage_chat")
        var parsed_can_manage_chat = data.boolean_value(parsed_can_manage_chat_index)
        var parsed_can_delete_messages_index = data.object_get(data.root, "can_delete_messages")
        if parsed_can_delete_messages_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_delete_messages")
        var parsed_can_delete_messages = data.boolean_value(parsed_can_delete_messages_index)
        var parsed_can_manage_video_chats_index = data.object_get(data.root, "can_manage_video_chats")
        if parsed_can_manage_video_chats_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_manage_video_chats")
        var parsed_can_manage_video_chats = data.boolean_value(parsed_can_manage_video_chats_index)
        var parsed_can_restrict_members_index = data.object_get(data.root, "can_restrict_members")
        if parsed_can_restrict_members_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_restrict_members")
        var parsed_can_restrict_members = data.boolean_value(parsed_can_restrict_members_index)
        var parsed_can_promote_members_index = data.object_get(data.root, "can_promote_members")
        if parsed_can_promote_members_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_promote_members")
        var parsed_can_promote_members = data.boolean_value(parsed_can_promote_members_index)
        var parsed_can_change_info_index = data.object_get(data.root, "can_change_info")
        if parsed_can_change_info_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_change_info")
        var parsed_can_change_info = data.boolean_value(parsed_can_change_info_index)
        var parsed_can_invite_users_index = data.object_get(data.root, "can_invite_users")
        if parsed_can_invite_users_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_invite_users")
        var parsed_can_invite_users = data.boolean_value(parsed_can_invite_users_index)
        var parsed_can_post_stories_index = data.object_get(data.root, "can_post_stories")
        if parsed_can_post_stories_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_post_stories")
        var parsed_can_post_stories = data.boolean_value(parsed_can_post_stories_index)
        var parsed_can_edit_stories_index = data.object_get(data.root, "can_edit_stories")
        if parsed_can_edit_stories_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_edit_stories")
        var parsed_can_edit_stories = data.boolean_value(parsed_can_edit_stories_index)
        var parsed_can_delete_stories_index = data.object_get(data.root, "can_delete_stories")
        if parsed_can_delete_stories_index == -1:
            raise Error("ChatAdministratorRights JSON object is missing can_delete_stories")
        var parsed_can_delete_stories = data.boolean_value(parsed_can_delete_stories_index)
        var parsed_can_post_messages_index = data.object_get(data.root, "can_post_messages")
        var parsed_can_post_messages: Optional[Bool] = None
        if parsed_can_post_messages_index != -1 and not data.is_null(parsed_can_post_messages_index):
            parsed_can_post_messages = Optional[Bool](data.boolean_value(parsed_can_post_messages_index))
        var parsed_can_edit_messages_index = data.object_get(data.root, "can_edit_messages")
        var parsed_can_edit_messages: Optional[Bool] = None
        if parsed_can_edit_messages_index != -1 and not data.is_null(parsed_can_edit_messages_index):
            parsed_can_edit_messages = Optional[Bool](data.boolean_value(parsed_can_edit_messages_index))
        var parsed_can_pin_messages_index = data.object_get(data.root, "can_pin_messages")
        var parsed_can_pin_messages: Optional[Bool] = None
        if parsed_can_pin_messages_index != -1 and not data.is_null(parsed_can_pin_messages_index):
            parsed_can_pin_messages = Optional[Bool](data.boolean_value(parsed_can_pin_messages_index))
        var parsed_can_manage_topics_index = data.object_get(data.root, "can_manage_topics")
        var parsed_can_manage_topics: Optional[Bool] = None
        if parsed_can_manage_topics_index != -1 and not data.is_null(parsed_can_manage_topics_index):
            parsed_can_manage_topics = Optional[Bool](data.boolean_value(parsed_can_manage_topics_index))
        var parsed_can_manage_direct_messages_index = data.object_get(data.root, "can_manage_direct_messages")
        var parsed_can_manage_direct_messages: Optional[Bool] = None
        if parsed_can_manage_direct_messages_index != -1 and not data.is_null(parsed_can_manage_direct_messages_index):
            parsed_can_manage_direct_messages = Optional[Bool](data.boolean_value(parsed_can_manage_direct_messages_index))
        var parsed_can_manage_tags_index = data.object_get(data.root, "can_manage_tags")
        var parsed_can_manage_tags: Optional[Bool] = None
        if parsed_can_manage_tags_index != -1 and not data.is_null(parsed_can_manage_tags_index):
            parsed_can_manage_tags = Optional[Bool](data.boolean_value(parsed_can_manage_tags_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "is_anonymous" and key != "can_manage_chat" and key != "can_delete_messages" and key != "can_manage_video_chats" and key != "can_restrict_members" and key != "can_promote_members" and key != "can_change_info" and key != "can_invite_users" and key != "can_post_stories" and key != "can_edit_stories" and key != "can_delete_stories" and key != "can_post_messages" and key != "can_edit_messages" and key != "can_pin_messages" and key != "can_manage_topics" and key != "can_manage_direct_messages" and key != "can_manage_tags":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatAdministratorRights(parsed_is_anonymous, parsed_can_manage_chat, parsed_can_delete_messages, parsed_can_manage_video_chats, parsed_can_restrict_members, parsed_can_promote_members, parsed_can_change_info, parsed_can_invite_users, parsed_can_post_stories, parsed_can_edit_stories, parsed_can_delete_stories, parsed_can_post_messages, parsed_can_edit_messages, parsed_can_pin_messages, parsed_can_manage_topics, parsed_can_manage_direct_messages, parsed_can_manage_tags, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatAdministratorRights]:
        var items = data.array_documents(array_index)
        var result = List[ChatAdministratorRights]()
        for index in range(len(items)):
            result.append(ChatAdministratorRights.de_json(items[index].copy()))
        return result^

    @staticmethod
    def all_rights() -> ChatAdministratorRights:
        return ChatAdministratorRights(True, True, True, True, True, True, True, True, True, True, True, Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True))

    @staticmethod
    def no_rights() -> ChatAdministratorRights:
        return ChatAdministratorRights(False, False, False, False, False, False, False, False, False, False, False, Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False))
