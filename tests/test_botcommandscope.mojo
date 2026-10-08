from std.testing import assert_equal

from telegram import (
    BotCommandScope,
    BotCommandScopeAllChatAdministrators,
    BotCommandScopeAllGroupChats,
    BotCommandScopeAllPrivateChats,
    BotCommandScopeChat,
    BotCommandScopeChatAdministrators,
    BotCommandScopeChatMember,
    BotCommandScopeDefault,
)
from telegram._utils.json import parse_json


def main() raises:
    var default_scope = BotCommandScopeDefault()
    assert_equal(default_scope.type, "default")
    assert_equal(default_scope.to_json(), "{\"type\": \"default\"}")
    var decoded_default = BotCommandScopeDefault.de_json(
        parse_json("{\"type\":\"default\"}")
    )
    assert_equal(decoded_default == default_scope, True)
    assert_equal(hash(decoded_default), hash(default_scope))

    var private_scope = BotCommandScopeAllPrivateChats()
    assert_equal(private_scope.to_json(), "{\"type\": \"all_private_chats\"}")
    var group_scope = BotCommandScopeAllGroupChats()
    assert_equal(group_scope.to_json(), "{\"type\": \"all_group_chats\"}")
    var admin_scope = BotCommandScopeAllChatAdministrators()
    assert_equal(admin_scope.to_json(), "{\"type\": \"all_chat_administrators\"}")

    var parsed_scope = BotCommandScope.de_json(
        parse_json("{\"type\":\"all_group_chats\",\"future\":true}")
    )
    assert_equal(parsed_scope.type, "all_group_chats")
    assert_equal(
        parsed_scope.to_json(),
        "{\"type\": \"all_group_chats\", \"future\": true}",
    )

    var numeric_scope = BotCommandScopeChat(-100123)
    assert_equal(numeric_scope.type, "chat")
    assert_equal(
        numeric_scope.to_json(),
        "{\"type\": \"chat\", \"chat_id\": -100123}",
    )
    var numeric_round_trip = BotCommandScopeChat.de_json(
        parse_json("{\"type\":\"chat\",\"chat_id\":-100123}")
    )
    assert_equal(numeric_round_trip == numeric_scope, True)
    assert_equal(hash(numeric_round_trip), hash(numeric_scope))
    assert_equal(numeric_round_trip.chat_id.number, -100123)

    var username_scope = BotCommandScopeChat("@news_channel")
    assert_equal(
        username_scope.to_json(),
        "{\"type\": \"chat\", \"chat_id\": \"@news_channel\"}",
    )
    var username_round_trip = BotCommandScopeChat.de_json(
        parse_json("{\"type\":\"chat\",\"chat_id\":\"@news_channel\"}")
    )
    assert_equal(username_round_trip == username_scope, True)
    assert_equal(username_round_trip.chat_id.username, "@news_channel")

    var numeric_string_scope = BotCommandScopeChat("12345")
    assert_equal(numeric_string_scope.chat_id.number, 12345)
    var formatted_numeric_string_scope = BotCommandScopeChat("  +1_2345  ")
    assert_equal(formatted_numeric_string_scope.chat_id.number, 12345)

    var admins_scope = BotCommandScopeChatAdministrators("@news_channel")
    var admins_round_trip = BotCommandScopeChatAdministrators.de_json(
        parse_json("{\"type\":\"chat_administrators\",\"chat_id\":\"@news_channel\"}")
    )
    assert_equal(admins_round_trip == admins_scope, True)
    assert_equal(
        admins_round_trip.to_json(),
        "{\"type\": \"chat_administrators\", \"chat_id\": \"@news_channel\"}",
    )

    var member_scope = BotCommandScopeChatMember("@news_channel", 42)
    var member_round_trip = BotCommandScopeChatMember.de_json(
        parse_json("{\"type\":\"chat_member\",\"chat_id\":\"@news_channel\",\"user_id\":42}")
    )
    assert_equal(member_round_trip == member_scope, True)
    assert_equal(hash(member_round_trip), hash(member_scope))
    assert_equal(member_round_trip.user_id, 42)
    assert_equal(
        member_round_trip.to_json(),
        "{\"type\": \"chat_member\", \"chat_id\": \"@news_channel\", \"user_id\": 42}",
    )
