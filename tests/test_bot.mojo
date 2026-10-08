from std.testing import assert_equal, assert_raises

from telegram import Bot, User
from telegram._bot import _bot_request_data
from telegram._utils.json import JsonDocument, parse_json
from std.collections.optional import Optional


def main() raises:
    var bot = Bot(
        "!!Test String!!",
        base_url="base/",
        base_file_url="files/",
        local_mode=True,
    )
    assert_equal(bot.token, "!!Test String!!")
    assert_equal(bot.base_url, "base/!!Test String!!")
    assert_equal(bot.base_file_url, "files/!!Test String!!")
    assert_equal(bot.local_mode, True)
    assert_equal(bot.api_url("getMe"), "base/!!Test String!!/getMe")
    assert_equal(bot.file_url("documents/a"), "files/!!Test String!!/documents/a")

    var formatted = Bot(
        "secret",
        base_url="https://api.example/{token}/{TOKEN}/{bot_token}/{BOT_TOKEN}/{bot-token}/{BOT-TOKEN}",
        base_file_url="{{token}}/{token}",
    )
    assert_equal(
        formatted.base_url,
        "https://api.example/secret/secret/secret/secret/secret/secret",
    )
    assert_equal(formatted.base_file_url, "{token}/secret")
    var unicode_url = Bot("key", base_url="https://例.example/{token}")
    assert_equal(unicode_url.base_url, "https://例.example/key")

    var defaults = Bot("key")
    assert_equal(defaults.base_url, "https://api.telegram.org/botkey")
    assert_equal(defaults.base_file_url, "https://api.telegram.org/file/botkey")
    assert_equal(defaults.request.connection_pool_size, 256)
    assert_equal(defaults.get_updates_request.connection_pool_size, 1)
    assert_equal(Bot("secret", base_url="{unknown}").base_url, "{unknown}secret")

    with assert_raises():
        _ = defaults.decrypt_private_secret("YQ==")
    with assert_raises():
        _ = Bot(
            "passport-token",
            private_key=Optional[String]("invalid test key"),
            private_key_password=Optional[String]("test password"),
        )

    var api_parameters = parse_json('{"chat_id":123,"text":"hello world"}')
    var native_request_data = _bot_request_data(Optional[JsonDocument](api_parameters.copy()))
    assert_equal(
        native_request_data.url_encoded_parameters(),
        "chat_id=123&text=hello+world",
    )

    with assert_raises():
        _ = Bot("")
    with assert_raises():
        _ = Bot("token", base_url="{unknown}{token}")
    with assert_raises():
        _ = bot.id()

    var user = User.de_json(parse_json(
        '{"id":123,"first_name":"Ada","is_bot":true,"username":"ada_bot"}'
    ))
    bot.set_bot_user(user)
    assert_equal(bot.bot_initialized, True)
    assert_equal(bot.id(), 123)
    assert_equal(bot.first_name(), "Ada")
    assert_equal(bot.username().value(), "ada_bot")
    assert_equal(bot.link(), "https://t.me/ada_bot")
    assert_equal(bot.name(), "@ada_bot")
    var bot_data = bot.to_dict()
    assert_equal(bot_data.object_get(bot_data.root, "id") != -1, True)
    assert_equal(bot.__repr__(), "Bot[token=!!Test String!!]")
