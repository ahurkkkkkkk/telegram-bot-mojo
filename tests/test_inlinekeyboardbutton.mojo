from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    CallbackGame,
    CopyTextButton,
    InlineKeyboardButton,
    LoginUrl,
    SwitchInlineQueryChosenChat,
    WebAppInfo,
)
from telegram._utils.json import parse_json


def main() raises:
    var button = InlineKeyboardButton(
        "open",
        url=Optional[String]("https://example.com"),
        callback_data=Optional[String]("cb"),
        callback_game=Optional[CallbackGame](CallbackGame()),
        login_url=Optional[LoginUrl](LoginUrl("https://login.example")),
        web_app=Optional[WebAppInfo](WebAppInfo("https://app.example")),
        switch_inline_query_chosen_chat=Optional[SwitchInlineQueryChosenChat](
            SwitchInlineQueryChosenChat(query="find", allow_user_chats=True)
        ),
        copy_text=Optional[CopyTextButton](CopyTextButton("copy")),
        style=Optional[String]("primary"),
        icon_custom_emoji_id=Optional[String]("emoji-id"),
    )
    assert_equal(button.text, "open")
    assert_equal(button.callback_data.value(), "cb")
    assert_equal(button.login_url.value().url, "https://login.example")
    assert_equal(button.web_app.value().url, "https://app.example")
    assert_equal(button.to_dict().object_get(button.to_dict().root, "callback_game") != -1, True)

    var decoded = InlineKeyboardButton.de_json(
        parse_json(
            '{"text":"open","url":"https://example.com","callback_data":"cb","callback_game":{},"login_url":{"url":"https://login.example"},"web_app":{"url":"https://app.example"},"switch_inline_query_chosen_chat":{"query":"find","allow_user_chats":true},"copy_text":{"text":"copy"},"style":"primary","icon_custom_emoji_id":"emoji-id","future":7}'
        )
    )
    assert_equal(decoded == button, True)
    assert_equal(decoded.copy_text.value().text, "copy")
    assert_equal(decoded.api_kwargs.object_get(decoded.api_kwargs.root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "future") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "switch_inline_query_chosen_chat") != -1, True)
    assert_equal(decoded.to_dict().object_get(decoded.to_dict().root, "copy_text") != -1, True)
    assert_equal(InlineKeyboardButton.MIN_CALLBACK_DATA, 1)
    assert_equal(InlineKeyboardButton.MAX_CALLBACK_DATA, 64)

    var same_identity = InlineKeyboardButton(
        "open", copy_text=Optional[CopyTextButton](CopyTextButton("different"))
    )
    assert_equal(InlineKeyboardButton("open") == same_identity, True)
    var changed = InlineKeyboardButton("changed")
    changed.update_callback_data("updated")
    assert_equal(changed.callback_data.value(), "updated")
    with assert_raises():
        _ = InlineKeyboardButton.de_json(parse_json("{}"))
