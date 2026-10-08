from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram._user import User as TelegramUser
from telegram._messageentity import MessageEntity
from telegram.ext.filters import (
    Chat,
    ChatAllowEmpty,
    Dice,
    ForwardedFrom,
    ForwardedFromAllowEmpty,
    Language,
    Mention,
    SenderChat,
    SenderChatAllowEmpty,
    User,
    UserAllowEmpty,
    ViaBot,
    _mention_entity_text,
    _normalize_mention_text,
)


def main() raises:
    assert_equal(Chat(12).program, "@c")
    assert_equal(Chat(12).parameters, "2:12")
    assert_equal(Dice.Filter(4).program, "@d")
    assert_equal(Dice.Basketball(5).program, "@o@d&")
    assert_equal(Dice.Basketball(5).parameters, "4:🏀1:5")
    assert_equal(User("alice").program, "@j")
    assert_equal(ViaBot(42).program, "@b")
    assert_equal(SenderChat(-100).program, "@s")
    assert_equal(ForwardedFrom(777).program, "@f")

    var ids = List[Int]()
    ids.append(10)
    ids.append(20)
    assert_equal(Chat(ids.copy()).program, "@c@c|")
    var values = List[Int]()
    values.append(2)
    values.append(4)
    assert_equal(Dice.Filter(values.copy()).program, "@d@d|")
    assert_equal(Dice.SlotMachine(values.copy()).program, "@o@d&@o@d&|")
    assert_equal(Dice.Dice(3).program, "@o@d&")
    assert_equal(Dice.Bowling(2).program, "@o@d&")

    var names = List[String]()
    names.append("@news")
    names.append("helper")
    var chats = Chat(names.copy())
    assert_equal(chats.program, "@h@h|")
    assert_equal(chats.parameters, "4:news6:helper")
    assert_equal(chats.name, "filters.Chat(news, helper)")
    assert_equal(ChatAllowEmpty().program, "@k")
    assert_equal(ChatAllowEmpty().name, "filters.Chat()")
    assert_equal(User(42).program, "@i")
    assert_equal(UserAllowEmpty().program, "@q")
    assert_equal(ViaBot("helperbot").program, "@B")
    assert_equal(SenderChatAllowEmpty().program, "@y")
    assert_equal(ForwardedFromAllowEmpty().program, "@z")

    var mutable_chat = Chat(12)
    mutable_chat.add_chat_ids(13)
    assert_equal(mutable_chat.program, "@c@c|")
    assert_equal(mutable_chat.parameters, "2:122:13")
    assert_equal(mutable_chat.name, "filters.Chat(12, 13)")
    var current_chat_ids = mutable_chat.chat_ids()
    assert_equal(current_chat_ids[0], 12)
    assert_equal(current_chat_ids[1], 13)
    mutable_chat.add_chat_ids(13)
    assert_equal(mutable_chat.program, "@c@c|")
    mutable_chat.remove_chat_ids(12)
    assert_equal(mutable_chat.program, "@c")
    assert_equal(mutable_chat.name, "filters.Chat(13)")
    mutable_chat.remove_chat_ids(13)
    assert_equal(mutable_chat.program, "?")
    mutable_chat.set_allow_empty(True)
    assert_equal(mutable_chat.program, "@k")
    var no_chat_ids = List[Int]()
    mutable_chat.set_chat_ids(no_chat_ids^)
    assert_equal(mutable_chat.name, "filters.Chat()")
    mutable_chat.set_allow_empty(False)
    assert_equal(mutable_chat.program, "?")
    var empty_username_set = List[String]()
    var empty_id_set = List[Int]()
    var identity_with_name = Chat("channel")
    identity_with_name.set_chat_ids(empty_id_set^)
    assert_equal(identity_with_name.program, "@h")
    var identity_with_id = Chat(4)
    identity_with_id.set_usernames(empty_username_set^)
    assert_equal(identity_with_id.program, "@c")

    var mutable_sender_chat = SenderChat()
    var sender_chat_ids = List[Int]()
    sender_chat_ids.append(-20)
    sender_chat_ids.append(-21)
    mutable_sender_chat.add_chat_ids(sender_chat_ids.copy())
    assert_equal(mutable_sender_chat.chat_ids()[1], -21)
    mutable_sender_chat.remove_chat_ids(sender_chat_ids.copy())
    assert_equal(mutable_sender_chat.program, "?")

    var mutable_forwarded = ForwardedFrom()
    mutable_forwarded.add_chat_ids(500)
    assert_equal(mutable_forwarded.chat_ids()[0], 500)
    mutable_forwarded.set_chat_ids(501)
    assert_equal(mutable_forwarded.chat_ids()[0], 501)

    var mutable_user = User()
    mutable_user.add_usernames("@alice")
    assert_equal(mutable_user.program, "@j")
    assert_equal(mutable_user.parameters, "5:alice")
    var current_usernames = mutable_user.usernames()
    assert_equal(current_usernames[0], "alice")
    mutable_user.set_usernames(names.copy())
    assert_equal(mutable_user.program, "@j@j|")
    mutable_user.remove_usernames("@news")
    assert_equal(mutable_user.usernames()[0], "helper")
    var mutable_ids_user = User()
    var user_id_list = List[Int]()
    user_id_list.append(7)
    user_id_list.append(8)
    mutable_ids_user.add_user_ids(user_id_list.copy())
    assert_equal(mutable_ids_user.user_ids()[1], 8)
    mutable_ids_user.remove_user_ids(user_id_list.copy())
    assert_equal(mutable_ids_user.program, "?")
    var mutable_bot = ViaBot()
    var bot_id_list = List[Int]()
    bot_id_list.append(99)
    bot_id_list.append(100)
    mutable_bot.add_bot_ids(bot_id_list.copy())
    assert_equal(mutable_bot.bot_ids()[0], 99)
    mutable_bot.set_bot_ids(100)
    assert_equal(mutable_bot.bot_ids()[0], 100)

    var conflicting_identity_config = False
    try:
        var invalid = Chat(1, "news")
        _ = invalid
    except:
        conflicting_identity_config = True
    assert_equal(conflicting_identity_config, True)

    assert_equal(Mention("@alice").program, "@m")
    assert_equal(Mention("@alice").name, "filters.Mention(@alice)")
    assert_equal(Language("en").program, "@L")
    assert_equal(Mention(42).program, "@u")
    var mention_names = List[String]()
    mention_names.append("@alice")
    mention_names.append("bob")
    var mentions = Mention(mention_names.copy())
    assert_equal(mentions.program, "@m@m|")
    assert_equal(mentions.parameters, "5:alice3:bob")
    assert_equal(mentions.name, "filters.Mention(['@alice', 'bob'])")

    var mentioned_user = TelegramUser(
        42, "Alice", False, username=Optional[String]("alice")
    )
    var user_mention = Mention(mentioned_user.copy())
    assert_equal(user_mention.program, "@u@v|@m|")
    assert_equal(user_mention.parameters, "2:425:alice5:alice")
    var mention_users = List[TelegramUser]()
    mention_users.append(mentioned_user.copy())
    assert_equal(Mention(mention_users.copy()).program, "@u@v|@m|")

    var unicode_text = "a😀@alice"
    var mention_entity = MessageEntity(MessageEntity.MENTION, 3, 6)
    var entity_text = _mention_entity_text(unicode_text, mention_entity)
    assert_equal(entity_text[0], "@alice")
    assert_equal(entity_text[1], True)
    assert_equal(_normalize_mention_text(entity_text[0]), "alice")
    var split_surrogate = MessageEntity(MessageEntity.MENTION, 2, 1)
    assert_equal(_mention_entity_text(unicode_text, split_surrogate)[1], False)
