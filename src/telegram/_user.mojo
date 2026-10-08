#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 User.
# LGPL-3.0-or-later; see LICENSE.

"""A Telegram user or bot, with native JSON and mention helpers."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram.helpers import mention_html as helpers_mention_html
from telegram.helpers import mention_markdown as helpers_mention_markdown


def _user_optional_bool(data: JsonDocument, key: String) raises -> Optional[Bool]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[Bool](data.boolean_value(index))


def _user_optional_string(data: JsonDocument, key: String) raises -> Optional[String]:
    var index = data.object_get(data.root, key)
    if index == -1 or data.is_null(index):
        return None
    return Optional[String](data.string_value(index))


struct User(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A Telegram user or bot; equality follows upstream and uses only ``id``."""

    var id: Int
    var first_name: String
    var is_bot: Bool
    var last_name: Optional[String]
    var username: Optional[String]
    var language_code: Optional[String]
    var can_join_groups: Optional[Bool]
    var can_read_all_group_messages: Optional[Bool]
    var supports_inline_queries: Optional[Bool]
    var is_premium: Optional[Bool]
    var added_to_attachment_menu: Optional[Bool]
    var can_connect_to_business: Optional[Bool]
    var has_main_web_app: Optional[Bool]
    var has_topics_enabled: Optional[Bool]
    var allows_users_to_create_topics: Optional[Bool]
    var can_manage_bots: Optional[Bool]
    var supports_guest_queries: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: Int,
        first_name: String,
        is_bot: Bool,
        last_name: Optional[String] = None,
        username: Optional[String] = None,
        language_code: Optional[String] = None,
        can_join_groups: Optional[Bool] = None,
        can_read_all_group_messages: Optional[Bool] = None,
        supports_inline_queries: Optional[Bool] = None,
        is_premium: Optional[Bool] = None,
        added_to_attachment_menu: Optional[Bool] = None,
        can_connect_to_business: Optional[Bool] = None,
        has_main_web_app: Optional[Bool] = None,
        has_topics_enabled: Optional[Bool] = None,
        allows_users_to_create_topics: Optional[Bool] = None,
        can_manage_bots: Optional[Bool] = None,
        supports_guest_queries: Optional[Bool] = None,
    ):
        self.id = id
        self.first_name = first_name.copy()
        self.is_bot = is_bot
        self.last_name = last_name
        self.username = username
        self.language_code = language_code
        self.can_join_groups = can_join_groups
        self.can_read_all_group_messages = can_read_all_group_messages
        self.supports_inline_queries = supports_inline_queries
        self.is_premium = is_premium
        self.added_to_attachment_menu = added_to_attachment_menu
        self.can_connect_to_business = can_connect_to_business
        self.has_main_web_app = has_main_web_app
        self.has_topics_enabled = has_topics_enabled
        self.allows_users_to_create_topics = allows_users_to_create_topics
        self.can_manage_bots = can_manage_bots
        self.supports_guest_queries = supports_guest_queries
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: Int,
        first_name: String,
        is_bot: Bool,
        last_name: Optional[String] = None,
        username: Optional[String] = None,
        language_code: Optional[String] = None,
        can_join_groups: Optional[Bool] = None,
        can_read_all_group_messages: Optional[Bool] = None,
        supports_inline_queries: Optional[Bool] = None,
        is_premium: Optional[Bool] = None,
        added_to_attachment_menu: Optional[Bool] = None,
        can_connect_to_business: Optional[Bool] = None,
        has_main_web_app: Optional[Bool] = None,
        has_topics_enabled: Optional[Bool] = None,
        allows_users_to_create_topics: Optional[Bool] = None,
        can_manage_bots: Optional[Bool] = None,
        supports_guest_queries: Optional[Bool] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id
        self.first_name = first_name.copy()
        self.is_bot = is_bot
        self.last_name = last_name
        self.username = username
        self.language_code = language_code
        self.can_join_groups = can_join_groups
        self.can_read_all_group_messages = can_read_all_group_messages
        self.supports_inline_queries = supports_inline_queries
        self.is_premium = is_premium
        self.added_to_attachment_menu = added_to_attachment_menu
        self.can_connect_to_business = can_connect_to_business
        self.has_main_web_app = has_main_web_app
        self.has_topics_enabled = has_topics_enabled
        self.allows_users_to_create_topics = allows_users_to_create_topics
        self.can_manage_bots = can_manage_bots
        self.supports_guest_queries = supports_guest_queries
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id
        self.first_name = existing.first_name.copy()
        self.is_bot = existing.is_bot
        self.last_name = existing.last_name
        self.username = existing.username
        self.language_code = existing.language_code
        self.can_join_groups = existing.can_join_groups
        self.can_read_all_group_messages = existing.can_read_all_group_messages
        self.supports_inline_queries = existing.supports_inline_queries
        self.is_premium = existing.is_premium
        self.added_to_attachment_menu = existing.added_to_attachment_menu
        self.can_connect_to_business = existing.can_connect_to_business
        self.has_main_web_app = existing.has_main_web_app
        self.has_topics_enabled = existing.has_topics_enabled
        self.allows_users_to_create_topics = existing.allows_users_to_create_topics
        self.can_manage_bots = existing.can_manage_bots
        self.supports_guest_queries = existing.supports_guest_queries
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.id).as_bytes())

    def name(self) -> String:
        if self.username is not None and self.username.value().byte_length() > 0:
            return String("@", self.username.value())
        return self.full_name()

    def full_name(self) -> String:
        if self.last_name is not None and self.last_name.value().byte_length() > 0:
            return String(self.first_name, " ", self.last_name.value())
        return self.first_name.copy()

    def link(self) -> Optional[String]:
        if self.username is not None and self.username.value().byte_length() > 0:
            return Optional[String](String("https://t.me/", self.username.value()))
        return None

    def mention_html(self, name: Optional[String] = None) -> String:
        if name is not None and name.value().byte_length() > 0:
            return helpers_mention_html(self.id, name.value())
        return helpers_mention_html(self.id, self.full_name())

    def mention_markdown(self, name: Optional[String] = None) raises -> String:
        if name is not None and name.value().byte_length() > 0:
            return helpers_mention_markdown(self.id, name.value())
        return helpers_mention_markdown(self.id, self.full_name())

    def mention_markdown_v2(self, name: Optional[String] = None) raises -> String:
        if name is not None and name.value().byte_length() > 0:
            return helpers_mention_markdown(self.id, name.value(), version=2)
        return helpers_mention_markdown(self.id, self.full_name(), version=2)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "id", String(self.id))
        result.set_string(result.root, "first_name", self.first_name)
        result.set_boolean(result.root, "is_bot", self.is_bot)
        if self.last_name is not None:
            result.set_string(result.root, "last_name", self.last_name.value())
        if self.username is not None:
            result.set_string(result.root, "username", self.username.value())
        if self.language_code is not None:
            result.set_string(result.root, "language_code", self.language_code.value())
        if self.can_join_groups is not None:
            result.set_boolean(result.root, "can_join_groups", self.can_join_groups.value())
        if self.can_read_all_group_messages is not None:
            result.set_boolean(
                result.root, "can_read_all_group_messages", self.can_read_all_group_messages.value()
            )
        if self.supports_inline_queries is not None:
            result.set_boolean(result.root, "supports_inline_queries", self.supports_inline_queries.value())
        if self.is_premium is not None:
            result.set_boolean(result.root, "is_premium", self.is_premium.value())
        if self.added_to_attachment_menu is not None:
            result.set_boolean(
                result.root, "added_to_attachment_menu", self.added_to_attachment_menu.value()
            )
        if self.can_connect_to_business is not None:
            result.set_boolean(
                result.root, "can_connect_to_business", self.can_connect_to_business.value()
            )
        if self.has_main_web_app is not None:
            result.set_boolean(result.root, "has_main_web_app", self.has_main_web_app.value())
        if self.has_topics_enabled is not None:
            result.set_boolean(result.root, "has_topics_enabled", self.has_topics_enabled.value())
        if self.allows_users_to_create_topics is not None:
            result.set_boolean(
                result.root,
                "allows_users_to_create_topics",
                self.allows_users_to_create_topics.value(),
            )
        if self.can_manage_bots is not None:
            result.set_boolean(result.root, "can_manage_bots", self.can_manage_bots.value())
        if self.supports_guest_queries is not None:
            result.set_boolean(
                result.root, "supports_guest_queries", self.supports_guest_queries.value()
            )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("User JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("User JSON value is not an object")
        var id_index = data.object_get(data.root, "id")
        var first_name_index = data.object_get(data.root, "first_name")
        var is_bot_index = data.object_get(data.root, "is_bot")
        if id_index == -1 or first_name_index == -1 or is_bot_index == -1:
            raise Error("User JSON object is missing a required field")
        var id = data.integer_value(id_index)
        var first_name = data.string_value(first_name_index)
        var is_bot = data.boolean_value(is_bot_index)
        var last_name = _user_optional_string(data, "last_name")
        var username = _user_optional_string(data, "username")
        var language_code = _user_optional_string(data, "language_code")
        var can_join_groups = _user_optional_bool(data, "can_join_groups")
        var can_read_all_group_messages = _user_optional_bool(data, "can_read_all_group_messages")
        var supports_inline_queries = _user_optional_bool(data, "supports_inline_queries")
        var is_premium = _user_optional_bool(data, "is_premium")
        var added_to_attachment_menu = _user_optional_bool(data, "added_to_attachment_menu")
        var can_connect_to_business = _user_optional_bool(data, "can_connect_to_business")
        var has_main_web_app = _user_optional_bool(data, "has_main_web_app")
        var has_topics_enabled = _user_optional_bool(data, "has_topics_enabled")
        var allows_users_to_create_topics = _user_optional_bool(data, "allows_users_to_create_topics")
        var can_manage_bots = _user_optional_bool(data, "can_manage_bots")
        var supports_guest_queries = _user_optional_bool(data, "supports_guest_queries")

        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if (
                key != "id"
                and key != "first_name"
                and key != "is_bot"
                and key != "last_name"
                and key != "username"
                and key != "language_code"
                and key != "can_join_groups"
                and key != "can_read_all_group_messages"
                and key != "supports_inline_queries"
                and key != "is_premium"
                and key != "added_to_attachment_menu"
                and key != "can_connect_to_business"
                and key != "has_main_web_app"
                and key != "has_topics_enabled"
                and key != "allows_users_to_create_topics"
                and key != "can_manage_bots"
                and key != "supports_guest_queries"
            ):
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return User(
            id,
            first_name,
            is_bot,
            last_name,
            username,
            language_code,
            can_join_groups,
            can_read_all_group_messages,
            supports_inline_queries,
            is_premium,
            added_to_attachment_menu,
            can_connect_to_business,
            has_main_web_app,
            has_topics_enabled,
            allows_users_to_create_topics,
            can_manage_bots,
            supports_guest_queries,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(User.de_json(items[index].copy()))
        return result^
