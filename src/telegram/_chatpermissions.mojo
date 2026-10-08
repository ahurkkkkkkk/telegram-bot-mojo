#!/usr/bin/env mojo
#
# Native Mojo nullable-scalar translations from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native nullable-scalar Telegram models translated from _chatpermissions.py."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object

struct ChatPermissions(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Native nullable-scalar model translated from upstream ChatPermissions."""

    var can_send_messages: Optional[Bool]
    var can_send_polls: Optional[Bool]
    var can_send_other_messages: Optional[Bool]
    var can_add_web_page_previews: Optional[Bool]
    var can_change_info: Optional[Bool]
    var can_invite_users: Optional[Bool]
    var can_pin_messages: Optional[Bool]
    var can_manage_topics: Optional[Bool]
    var can_send_audios: Optional[Bool]
    var can_send_documents: Optional[Bool]
    var can_send_photos: Optional[Bool]
    var can_send_videos: Optional[Bool]
    var can_send_video_notes: Optional[Bool]
    var can_send_voice_notes: Optional[Bool]
    var can_edit_tag: Optional[Bool]
    var can_react_to_messages: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, can_send_messages: Optional[Bool] = None, can_send_polls: Optional[Bool] = None, can_send_other_messages: Optional[Bool] = None, can_add_web_page_previews: Optional[Bool] = None, can_change_info: Optional[Bool] = None, can_invite_users: Optional[Bool] = None, can_pin_messages: Optional[Bool] = None, can_manage_topics: Optional[Bool] = None, can_send_audios: Optional[Bool] = None, can_send_documents: Optional[Bool] = None, can_send_photos: Optional[Bool] = None, can_send_videos: Optional[Bool] = None, can_send_video_notes: Optional[Bool] = None, can_send_voice_notes: Optional[Bool] = None, can_edit_tag: Optional[Bool] = None, can_react_to_messages: Optional[Bool] = None):
        self.can_send_messages = can_send_messages
        self.can_send_polls = can_send_polls
        self.can_send_other_messages = can_send_other_messages
        self.can_add_web_page_previews = can_add_web_page_previews
        self.can_change_info = can_change_info
        self.can_invite_users = can_invite_users
        self.can_pin_messages = can_pin_messages
        self.can_manage_topics = can_manage_topics
        self.can_send_audios = can_send_audios
        self.can_send_documents = can_send_documents
        self.can_send_photos = can_send_photos
        self.can_send_videos = can_send_videos
        self.can_send_video_notes = can_send_video_notes
        self.can_send_voice_notes = can_send_voice_notes
        self.can_edit_tag = can_edit_tag
        self.can_react_to_messages = can_react_to_messages
        self.api_kwargs = empty_json_object()

    def __init__(out self, can_send_messages: Optional[Bool] = None, can_send_polls: Optional[Bool] = None, can_send_other_messages: Optional[Bool] = None, can_add_web_page_previews: Optional[Bool] = None, can_change_info: Optional[Bool] = None, can_invite_users: Optional[Bool] = None, can_pin_messages: Optional[Bool] = None, can_manage_topics: Optional[Bool] = None, can_send_audios: Optional[Bool] = None, can_send_documents: Optional[Bool] = None, can_send_photos: Optional[Bool] = None, can_send_videos: Optional[Bool] = None, can_send_video_notes: Optional[Bool] = None, can_send_voice_notes: Optional[Bool] = None, can_edit_tag: Optional[Bool] = None, can_react_to_messages: Optional[Bool] = None, *, api_kwargs: JsonDocument):
        self.can_send_messages = can_send_messages
        self.can_send_polls = can_send_polls
        self.can_send_other_messages = can_send_other_messages
        self.can_add_web_page_previews = can_add_web_page_previews
        self.can_change_info = can_change_info
        self.can_invite_users = can_invite_users
        self.can_pin_messages = can_pin_messages
        self.can_manage_topics = can_manage_topics
        self.can_send_audios = can_send_audios
        self.can_send_documents = can_send_documents
        self.can_send_photos = can_send_photos
        self.can_send_videos = can_send_videos
        self.can_send_video_notes = can_send_video_notes
        self.can_send_voice_notes = can_send_voice_notes
        self.can_edit_tag = can_edit_tag
        self.can_react_to_messages = can_react_to_messages
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.can_send_messages = existing.can_send_messages
        self.can_send_polls = existing.can_send_polls
        self.can_send_other_messages = existing.can_send_other_messages
        self.can_add_web_page_previews = existing.can_add_web_page_previews
        self.can_change_info = existing.can_change_info
        self.can_invite_users = existing.can_invite_users
        self.can_pin_messages = existing.can_pin_messages
        self.can_manage_topics = existing.can_manage_topics
        self.can_send_audios = existing.can_send_audios
        self.can_send_documents = existing.can_send_documents
        self.can_send_photos = existing.can_send_photos
        self.can_send_videos = existing.can_send_videos
        self.can_send_video_notes = existing.can_send_video_notes
        self.can_send_voice_notes = existing.can_send_voice_notes
        self.can_edit_tag = existing.can_edit_tag
        self.can_react_to_messages = existing.can_react_to_messages
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.can_send_messages == other.can_send_messages and self.can_send_polls == other.can_send_polls and self.can_send_other_messages == other.can_send_other_messages and self.can_add_web_page_previews == other.can_add_web_page_previews and self.can_change_info == other.can_change_info and self.can_invite_users == other.can_invite_users and self.can_pin_messages == other.can_pin_messages and self.can_manage_topics == other.can_manage_topics and self.can_send_audios == other.can_send_audios and self.can_send_documents == other.can_send_documents and self.can_send_photos == other.can_send_photos and self.can_send_videos == other.can_send_videos and self.can_send_video_notes == other.can_send_video_notes and self.can_send_voice_notes == other.can_send_voice_notes and self.can_edit_tag == other.can_edit_tag and self.can_react_to_messages == other.can_react_to_messages

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.can_send_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_send_polls is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_polls.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_send_other_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_other_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_add_web_page_previews is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_add_web_page_previews.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_change_info is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_change_info.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_invite_users is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_invite_users.value():
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
        if self.can_send_audios is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_audios.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_send_documents is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_documents.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_send_photos is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_photos.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_send_videos is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_videos.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_send_video_notes is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_video_notes.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_send_voice_notes is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_send_voice_notes.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_edit_tag is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_edit_tag.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.can_react_to_messages is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.can_react_to_messages.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.can_add_web_page_previews is not None:
            result.set_boolean(result.root, "can_add_web_page_previews", self.can_add_web_page_previews.value())
        if self.can_change_info is not None:
            result.set_boolean(result.root, "can_change_info", self.can_change_info.value())
        if self.can_edit_tag is not None:
            result.set_boolean(result.root, "can_edit_tag", self.can_edit_tag.value())
        if self.can_invite_users is not None:
            result.set_boolean(result.root, "can_invite_users", self.can_invite_users.value())
        if self.can_manage_topics is not None:
            result.set_boolean(result.root, "can_manage_topics", self.can_manage_topics.value())
        if self.can_pin_messages is not None:
            result.set_boolean(result.root, "can_pin_messages", self.can_pin_messages.value())
        if self.can_react_to_messages is not None:
            result.set_boolean(result.root, "can_react_to_messages", self.can_react_to_messages.value())
        if self.can_send_audios is not None:
            result.set_boolean(result.root, "can_send_audios", self.can_send_audios.value())
        if self.can_send_documents is not None:
            result.set_boolean(result.root, "can_send_documents", self.can_send_documents.value())
        if self.can_send_messages is not None:
            result.set_boolean(result.root, "can_send_messages", self.can_send_messages.value())
        if self.can_send_other_messages is not None:
            result.set_boolean(result.root, "can_send_other_messages", self.can_send_other_messages.value())
        if self.can_send_photos is not None:
            result.set_boolean(result.root, "can_send_photos", self.can_send_photos.value())
        if self.can_send_polls is not None:
            result.set_boolean(result.root, "can_send_polls", self.can_send_polls.value())
        if self.can_send_video_notes is not None:
            result.set_boolean(result.root, "can_send_video_notes", self.can_send_video_notes.value())
        if self.can_send_videos is not None:
            result.set_boolean(result.root, "can_send_videos", self.can_send_videos.value())
        if self.can_send_voice_notes is not None:
            result.set_boolean(result.root, "can_send_voice_notes", self.can_send_voice_notes.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> ChatPermissions:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("ChatPermissions JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatPermissions JSON value is not an object")
        var parsed_can_send_messages_index = data.object_get(data.root, "can_send_messages")
        var parsed_can_send_messages: Optional[Bool] = None
        if parsed_can_send_messages_index != -1 and not data.is_null(parsed_can_send_messages_index):
            parsed_can_send_messages = Optional[Bool](data.boolean_value(parsed_can_send_messages_index))
        var parsed_can_send_polls_index = data.object_get(data.root, "can_send_polls")
        var parsed_can_send_polls: Optional[Bool] = None
        if parsed_can_send_polls_index != -1 and not data.is_null(parsed_can_send_polls_index):
            parsed_can_send_polls = Optional[Bool](data.boolean_value(parsed_can_send_polls_index))
        var parsed_can_send_other_messages_index = data.object_get(data.root, "can_send_other_messages")
        var parsed_can_send_other_messages: Optional[Bool] = None
        if parsed_can_send_other_messages_index != -1 and not data.is_null(parsed_can_send_other_messages_index):
            parsed_can_send_other_messages = Optional[Bool](data.boolean_value(parsed_can_send_other_messages_index))
        var parsed_can_add_web_page_previews_index = data.object_get(data.root, "can_add_web_page_previews")
        var parsed_can_add_web_page_previews: Optional[Bool] = None
        if parsed_can_add_web_page_previews_index != -1 and not data.is_null(parsed_can_add_web_page_previews_index):
            parsed_can_add_web_page_previews = Optional[Bool](data.boolean_value(parsed_can_add_web_page_previews_index))
        var parsed_can_change_info_index = data.object_get(data.root, "can_change_info")
        var parsed_can_change_info: Optional[Bool] = None
        if parsed_can_change_info_index != -1 and not data.is_null(parsed_can_change_info_index):
            parsed_can_change_info = Optional[Bool](data.boolean_value(parsed_can_change_info_index))
        var parsed_can_invite_users_index = data.object_get(data.root, "can_invite_users")
        var parsed_can_invite_users: Optional[Bool] = None
        if parsed_can_invite_users_index != -1 and not data.is_null(parsed_can_invite_users_index):
            parsed_can_invite_users = Optional[Bool](data.boolean_value(parsed_can_invite_users_index))
        var parsed_can_pin_messages_index = data.object_get(data.root, "can_pin_messages")
        var parsed_can_pin_messages: Optional[Bool] = None
        if parsed_can_pin_messages_index != -1 and not data.is_null(parsed_can_pin_messages_index):
            parsed_can_pin_messages = Optional[Bool](data.boolean_value(parsed_can_pin_messages_index))
        var parsed_can_manage_topics_index = data.object_get(data.root, "can_manage_topics")
        var parsed_can_manage_topics: Optional[Bool] = None
        if parsed_can_manage_topics_index != -1 and not data.is_null(parsed_can_manage_topics_index):
            parsed_can_manage_topics = Optional[Bool](data.boolean_value(parsed_can_manage_topics_index))
        var parsed_can_send_audios_index = data.object_get(data.root, "can_send_audios")
        var parsed_can_send_audios: Optional[Bool] = None
        if parsed_can_send_audios_index != -1 and not data.is_null(parsed_can_send_audios_index):
            parsed_can_send_audios = Optional[Bool](data.boolean_value(parsed_can_send_audios_index))
        var parsed_can_send_documents_index = data.object_get(data.root, "can_send_documents")
        var parsed_can_send_documents: Optional[Bool] = None
        if parsed_can_send_documents_index != -1 and not data.is_null(parsed_can_send_documents_index):
            parsed_can_send_documents = Optional[Bool](data.boolean_value(parsed_can_send_documents_index))
        var parsed_can_send_photos_index = data.object_get(data.root, "can_send_photos")
        var parsed_can_send_photos: Optional[Bool] = None
        if parsed_can_send_photos_index != -1 and not data.is_null(parsed_can_send_photos_index):
            parsed_can_send_photos = Optional[Bool](data.boolean_value(parsed_can_send_photos_index))
        var parsed_can_send_videos_index = data.object_get(data.root, "can_send_videos")
        var parsed_can_send_videos: Optional[Bool] = None
        if parsed_can_send_videos_index != -1 and not data.is_null(parsed_can_send_videos_index):
            parsed_can_send_videos = Optional[Bool](data.boolean_value(parsed_can_send_videos_index))
        var parsed_can_send_video_notes_index = data.object_get(data.root, "can_send_video_notes")
        var parsed_can_send_video_notes: Optional[Bool] = None
        if parsed_can_send_video_notes_index != -1 and not data.is_null(parsed_can_send_video_notes_index):
            parsed_can_send_video_notes = Optional[Bool](data.boolean_value(parsed_can_send_video_notes_index))
        var parsed_can_send_voice_notes_index = data.object_get(data.root, "can_send_voice_notes")
        var parsed_can_send_voice_notes: Optional[Bool] = None
        if parsed_can_send_voice_notes_index != -1 and not data.is_null(parsed_can_send_voice_notes_index):
            parsed_can_send_voice_notes = Optional[Bool](data.boolean_value(parsed_can_send_voice_notes_index))
        var parsed_can_edit_tag_index = data.object_get(data.root, "can_edit_tag")
        var parsed_can_edit_tag: Optional[Bool] = None
        if parsed_can_edit_tag_index != -1 and not data.is_null(parsed_can_edit_tag_index):
            parsed_can_edit_tag = Optional[Bool](data.boolean_value(parsed_can_edit_tag_index))
        var parsed_can_react_to_messages_index = data.object_get(data.root, "can_react_to_messages")
        var parsed_can_react_to_messages: Optional[Bool] = None
        if parsed_can_react_to_messages_index != -1 and not data.is_null(parsed_can_react_to_messages_index):
            parsed_can_react_to_messages = Optional[Bool](data.boolean_value(parsed_can_react_to_messages_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "can_send_messages" and key != "can_send_polls" and key != "can_send_other_messages" and key != "can_add_web_page_previews" and key != "can_change_info" and key != "can_invite_users" and key != "can_pin_messages" and key != "can_manage_topics" and key != "can_send_audios" and key != "can_send_documents" and key != "can_send_photos" and key != "can_send_videos" and key != "can_send_video_notes" and key != "can_send_voice_notes" and key != "can_edit_tag" and key != "can_react_to_messages":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return ChatPermissions(parsed_can_send_messages, parsed_can_send_polls, parsed_can_send_other_messages, parsed_can_add_web_page_previews, parsed_can_change_info, parsed_can_invite_users, parsed_can_pin_messages, parsed_can_manage_topics, parsed_can_send_audios, parsed_can_send_documents, parsed_can_send_photos, parsed_can_send_videos, parsed_can_send_video_notes, parsed_can_send_voice_notes, parsed_can_edit_tag, parsed_can_react_to_messages, api_kwargs=api_kwargs)

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[ChatPermissions]:
        var items = data.array_documents(array_index)
        var result = List[ChatPermissions]()
        for index in range(len(items)):
            result.append(ChatPermissions.de_json(items[index].copy()))
        return result^

    @staticmethod
    def all_permissions() -> ChatPermissions:
        return ChatPermissions(Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True), Optional[Bool](True))

    @staticmethod
    def no_permissions() -> ChatPermissions:
        return ChatPermissions(Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False), Optional[Bool](False))
