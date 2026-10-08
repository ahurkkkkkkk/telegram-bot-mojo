#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 ChatFullInfo.
# LGPL-3.0-or-later; see LICENSE.

"""Full chat metadata with typed base/required fields and lossless JSON detail access."""

from std.hashlib.hasher import Hasher
from std.collections.optional import Optional

from telegram._chat import Chat
from telegram._gifts import AcceptedGiftTypes
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _chat_fullinfo_known(key: String) -> Bool:
    return (
        key == "id" or key == "type" or key == "title" or key == "username" or
        key == "first_name" or key == "last_name" or key == "is_forum" or
        key == "is_direct_messages" or key == "accent_color_id" or
        key == "accepted_gift_types" or key == "active_usernames" or
        key == "available_reactions" or key == "background_custom_emoji_id" or
        key == "bio" or key == "birthdate" or key == "business_intro" or
        key == "business_location" or key == "business_opening_hours" or
        key == "can_send_paid_media" or key == "can_set_sticker_set" or
        key == "custom_emoji_sticker_set_name" or key == "description" or
        key == "emoji_status_custom_emoji_id" or key == "emoji_status_expiration_date" or
        key == "first_profile_audio" or key == "has_aggressive_anti_spam_enabled" or
        key == "has_hidden_members" or key == "has_private_forwards" or
        key == "has_protected_content" or key == "has_restricted_voice_and_video_messages" or
        key == "has_visible_history" or key == "invite_link" or key == "join_by_request" or
        key == "join_to_send_messages" or key == "linked_chat_id" or key == "location" or
        key == "max_reaction_count" or key == "message_auto_delete_time" or
        key == "paid_message_star_count" or key == "parent_chat" or key == "permissions" or
        key == "personal_chat" or key == "photo" or key == "pinned_message" or
        key == "profile_accent_color_id" or key == "profile_background_custom_emoji_id" or
        key == "rating" or key == "slow_mode_delay" or key == "sticker_set_name" or
        key == "unique_gift_colors" or key == "unrestrict_boost_count"
    )


struct ChatFullInfo(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Detailed chat value; equality and hashing use the base Chat ID."""

    var chat: Chat
    var accent_color_id: Int
    var max_reaction_count: Int
    var accepted_gift_types: AcceptedGiftTypes
    var full_data: JsonDocument
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        chat: Chat,
        accent_color_id: Int,
        max_reaction_count: Int,
        accepted_gift_types: AcceptedGiftTypes,
        full_data: JsonDocument,
        api_kwargs: JsonDocument,
    ):
        self.chat = chat.copy()
        self.accent_color_id = accent_color_id
        self.max_reaction_count = max_reaction_count
        self.accepted_gift_types = accepted_gift_types.copy()
        self.full_data = full_data.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.accent_color_id = existing.accent_color_id
        self.max_reaction_count = existing.max_reaction_count
        self.accepted_gift_types = existing.accepted_gift_types.copy()
        self.full_data = existing.full_data.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.chat.id == other.chat.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ChatFullInfo\0").as_bytes())
        hasher.update(String(self.chat.id).as_bytes())

    def has_field(self, key: String) raises -> Bool:
        return self.full_data.object_get(self.full_data.root, key) != -1

    def field_json(self, key: String) raises -> JsonDocument:
        var index = self.full_data.object_get(self.full_data.root, key)
        if index == -1:
            raise Error(String("ChatFullInfo has no field: ", key))
        var result = JsonDocument()
        result.root = result.copy_subtree_from(self.full_data, index)
        return result^

    def optional_string_field(self, key: String) raises -> Optional[String]:
        var index = self.full_data.object_get(self.full_data.root, key)
        if index == -1 or self.full_data.is_null(index):
            return None
        return Optional[String](self.full_data.string_value(index))

    def optional_integer_field(self, key: String) raises -> Optional[Int]:
        var index = self.full_data.object_get(self.full_data.root, key)
        if index == -1 or self.full_data.is_null(index):
            return None
        return Optional[Int](self.full_data.integer_value(index))

    def optional_boolean_field(self, key: String) raises -> Optional[Bool]:
        var index = self.full_data.object_get(self.full_data.root, key)
        if index == -1 or self.full_data.is_null(index):
            return None
        return Optional[Bool](self.full_data.boolean_value(index))

    def array_field(self, key: String) raises -> List[JsonDocument]:
        var index = self.full_data.object_get(self.full_data.root, key)
        if index == -1:
            raise Error(String("ChatFullInfo has no field: ", key))
        if self.full_data.nodes[index].kind != JSON_ARRAY:
            raise Error(String("ChatFullInfo field is not an array: ", key))
        return self.full_data.array_documents(index)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        return self.full_data.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.full_data.copy())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatFullInfo JSON value must be an object")
        var accent_index = data.object_get(data.root, "accent_color_id")
        var reactions_index = data.object_get(data.root, "max_reaction_count")
        var gifts_index = data.object_get(data.root, "accepted_gift_types")
        if accent_index == -1 or reactions_index == -1 or gifts_index == -1:
            raise Error("ChatFullInfo JSON is missing required fields")
        var chat = Chat.de_json(data)
        var gifts_data = JsonDocument()
        gifts_data.root = gifts_data.copy_subtree_from(data, gifts_index)
        var accepted_gift_types = AcceptedGiftTypes.de_json(gifts_data)
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if not _chat_fullinfo_known(key):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return Self(
            chat,
            data.integer_value(accent_index),
            data.integer_value(reactions_index),
            accepted_gift_types,
            data,
            api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var documents = data.array_documents(array_index)
        var result = List[Self]()
        for document in documents:
            result.append(Self.de_json(document))
        return result^
