from std.testing import assert_equal, assert_raises

from telegram import (
    MenuButton,
    MenuButtonCommands,
    MenuButtonDefault,
    MenuButtonWebApp,
    WebAppInfo,
)
from telegram._utils.json import parse_json


def main() raises:
    assert_equal(MenuButton.COMMANDS, "commands")
    assert_equal(MenuButton.WEB_APP, "web_app")
    assert_equal(MenuButton.DEFAULT, "default")
    var commands = MenuButtonCommands()
    assert_equal(commands.type, "commands")
    assert_equal(commands.to_json(), "{\"type\": \"commands\"}")
    assert_equal(
        MenuButtonCommands.de_json(parse_json("{\"type\":\"commands\",\"future\":2}")).to_json(),
        "{\"type\": \"commands\", \"future\": 2}",
    )
    assert_equal(commands == MenuButtonCommands(), True)
    assert_equal(hash(commands), hash(MenuButtonCommands()))

    var default_button = MenuButtonDefault()
    assert_equal(default_button.type, "default")
    assert_equal(default_button.to_json(), "{\"type\": \"default\"}")
    assert_equal(
        MenuButtonDefault.de_json(parse_json("{\"future\":true}")).to_json(),
        "{\"type\": \"default\", \"future\": true}",
    )

    var web = WebAppInfo("https://example.test/app")
    var web_button = MenuButtonWebApp("Launch", web)
    assert_equal(web_button.type, "web_app")
    assert_equal(
        web_button.to_json(),
        "{\"type\": \"web_app\", \"text\": \"Launch\", \"web_app\": {\"url\": \"https://example.test/app\"}}",
    )
    var decoded_web = MenuButtonWebApp.de_json(
        parse_json("{\"type\":\"web_app\",\"text\":\"Launch\",\"web_app\":{\"url\":\"https://example.test/app\",\"nested\":1},\"future\":3}")
    )
    assert_equal(decoded_web.text, "Launch")
    assert_equal(
        decoded_web.to_json(),
        "{\"type\": \"web_app\", \"text\": \"Launch\", \"web_app\": {\"url\": \"https://example.test/app\", \"nested\": 1}, \"future\": 3}",
    )
    assert_equal(web_button == MenuButtonWebApp("Launch", web), True)
    assert_equal(hash(web_button), hash(MenuButtonWebApp("Launch", web)))

    var decoded_root = MenuButton.de_json(
        parse_json("{\"type\":\"web_app\",\"text\":\"Launch\",\"web_app\":{\"url\":\"https://example.test/app\"},\"future\":4}")
    )
    assert_equal(decoded_root.type, "web_app")
    assert_equal(decoded_root.text.value(), "Launch")
    assert_equal(
        decoded_root.to_json(),
        "{\"type\": \"web_app\", \"text\": \"Launch\", \"web_app\": {\"url\": \"https://example.test/app\"}, \"future\": 4}",
    )
    assert_equal(MenuButton.de_json(parse_json("{\"type\":\"commands\"}")).type, "commands")
    assert_equal(len(MenuButton.de_list(parse_json("[{\"type\":\"default\"}]"), 0)), 1)
    with assert_raises():
        _ = MenuButtonWebApp.de_json(parse_json("{\"text\":\"missing web app\"}"))
