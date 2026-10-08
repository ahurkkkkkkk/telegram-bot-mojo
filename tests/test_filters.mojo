from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram._update import Update
from telegram.ext.filters import (
    ALL,
    CAPTION,
    COMMAND,
    PHOTO,
    TEXT,
    BaseFilter,
    BOOST_ADDED,
    Chat,
    ChatAllowEmpty,
    Dice,
    DIRECT_MESSAGES,
    Document,
    Entity,
    FORUM,
    CaptionEntity,
    HAS_MEDIA_SPOILER,
    IS_AUTOMATIC_FORWARD,
    Language,
    Mention,
    PREMIUM_USER,
    StatusUpdate,
    Sticker,
    SenderChat,
    SenderChatAllowEmpty,
    SENDER_CHAT_ALL,
    SENDER_CHAT_CHANNEL,
    SENDER_CHAT_SUPER_GROUP,
    SUGGESTED_POST_INFO,
    USER,
    USER_ATTACHMENT,
    UPDATE_MESSAGE,
    Caption,
    Command,
    SuccessfulPayment,
    Text,
    User,
    ViaBot,
    ForwardedFrom,
    ForwardedFromAllowEmpty,
    _decode_parameter,
)


def main() raises:
    var conjunction: BaseFilter = TEXT & CAPTION
    assert_equal(conjunction.program, "TE&")
    assert_equal(conjunction.name, "<filters.TEXT and filters.CAPTION>")
    assert_equal(conjunction.data_filter, False)

    var disjunction: BaseFilter = PHOTO | TEXT
    assert_equal(disjunction.program, "PT|")
    assert_equal(disjunction.name, "<filters.PHOTO or filters.TEXT>")

    var exclusive: BaseFilter = PHOTO ^ COMMAND
    assert_equal(exclusive.program, "PG^")
    assert_equal(exclusive.name, "<filters.PHOTO xor filters.COMMAND>")

    var inverted: BaseFilter = ~COMMAND
    assert_equal(inverted.program, "G!")
    assert_equal(inverted.name, "<inverted filters.COMMAND>")

    var nested: BaseFilter = (TEXT & CAPTION) | PHOTO
    assert_equal(nested.program, "TE&P|")
    assert_equal(ALL.program, "A")

    assert_equal(StatusUpdate.ALL.program, ":*")
    assert_equal(StatusUpdate.CHAT_BACKGROUND_SET.name, "filters.StatusUpdate.CHAT_BACKGROUND_SET")
    assert_equal(StatusUpdate.POLL_OPTION_ADDED.program, ":d")
    assert_equal(UPDATE_MESSAGE.requires_message, False)
    var status_expression: BaseFilter = StatusUpdate.NEW_CHAT_MEMBERS | StatusUpdate.MIGRATE
    assert_equal(status_expression.program, ":Y:X|")
    assert_equal(status_expression.name, "<filters.StatusUpdate.NEW_CHAT_MEMBERS or filters.StatusUpdate.MIGRATE>")
    assert_equal(Sticker.ANIMATED.program, "h")
    assert_equal(Sticker.PREMIUM.name, "filters.Sticker.PREMIUM")
    assert_equal(Dice.ALL.program, "l")
    assert_equal(Dice.BOWLING.name, "filters.Dice.BOWLING")
    var values = List[Int]()
    values.append(3)
    values.append(6)
    var dice_values = Dice.Filter(values.copy())
    assert_equal(dice_values.program, "@d@d|")
    assert_equal(dice_values.parameters, "1:31:6")
    assert_equal(dice_values.name, "filters.Dice([3, 6])")
    var basketball_values = Dice.Basketball(values.copy())
    assert_equal(basketball_values.program, "@o@d&@o@d&|")
    assert_equal(basketball_values.parameters, "4:🏀1:34:🏀1:6")
    assert_equal(basketball_values.name, "filters.Dice.Basketball([3, 6])")
    assert_equal(Dice.Darts(4).program, "@o@d&")
    assert_equal(Dice.Darts(4).parameters, "4:🎯1:4")
    assert_equal(Chat(123).program, "@c")
    assert_equal(Chat(123).parameters, "3:123")
    assert_equal(Chat(123).name, "filters.Chat(123)")
    var usernames = List[String]()
    usernames.append("@news")
    usernames.append("bot")
    var chat_names = Chat(usernames.copy())
    assert_equal(chat_names.program, "@h@h|")
    assert_equal(chat_names.parameters, "4:news3:bot")
    assert_equal(ChatAllowEmpty().program, "@k")
    assert_equal(User(42).program, "@i")
    assert_equal(ViaBot("helperbot").program, "@B")
    assert_equal(SenderChatAllowEmpty().program, "@y")
    assert_equal(SenderChat(-100).parameters, "4:-100")
    assert_equal(ForwardedFrom(555).program, "@f")
    assert_equal(ForwardedFromAllowEmpty().program, "@z")
    assert_equal(SENDER_CHAT_ALL.name, "filters.SenderChat.ALL")
    assert_equal(SENDER_CHAT_CHANNEL.name, "filters.SenderChat.CHANNEL")
    assert_equal(SENDER_CHAT_SUPER_GROUP.name, "filters.SenderChat.SUPER_GROUP")
    assert_equal(Mention("@alice").program, "@m")
    assert_equal(Mention(42).program, "@u")
    var mention_usernames = List[String]()
    mention_usernames.append("@alice")
    mention_usernames.append("bob")
    var mention_names_filter = Mention(mention_usernames.copy())
    assert_equal(mention_names_filter.program, "@m@m|")
    assert_equal(mention_names_filter.parameters, "5:alice3:bob")
    assert_equal(DIRECT_MESSAGES.name, "filters.DIRECT_MESSAGES")
    assert_equal(FORUM.program, "u")
    assert_equal(HAS_MEDIA_SPOILER.name, "filters.HAS_MEDIA_SPOILER")
    assert_equal(IS_AUTOMATIC_FORWARD.program, "#")
    assert_equal(SUGGESTED_POST_INFO.name, "filters.SUGGESTED_POST_INFO")
    assert_equal(BOOST_ADDED.program, ";")
    assert_equal(USER.name, "filters.USER")
    assert_equal(USER_ATTACHMENT.program, "[")
    assert_equal(PREMIUM_USER.name, "filters.PREMIUM_USER")
    assert_equal(Command().program, COMMAND.program)
    assert_equal(Command(False).program, ">")
    assert_equal(Command(False).name, "filters.Command(False)")

    var exact_texts = List[String]()
    exact_texts.append("hello")
    exact_texts.append("world")
    var exact_text = Text(Optional[List[String]](exact_texts^))
    assert_equal(exact_text.program, "@T@T|")
    assert_equal(exact_text.name, "filters.Text(['hello', 'world'])")
    assert_equal(exact_text.parameters, "5:hello5:world")
    var decoded_parameter = _decode_parameter("5:hello4:🔥", 0)
    assert_equal(decoded_parameter[0], "hello")
    assert_equal(decoded_parameter[1], 7)
    var decoded_unicode_parameter = _decode_parameter("5:hello4:🔥", decoded_parameter[1])
    assert_equal(decoded_unicode_parameter[0], "🔥")
    assert_equal(decoded_unicode_parameter[1], 13)

    var exact_captions = List[String]()
    exact_captions.append("caption")
    var expression_texts = List[String]()
    expression_texts.append("hello")
    expression_texts.append("world")
    var caption_expression: BaseFilter = Text(Optional[List[String]](expression_texts^)) & Caption(Optional[List[String]](exact_captions^))
    assert_equal(caption_expression.program, "@T@T|@C&")
    assert_equal(caption_expression.parameters, "5:hello5:world7:caption")

    var payment_payloads = List[String]()
    payment_payloads.append("receipt")
    var payment_filter = SuccessfulPayment(Optional[List[String]](payment_payloads^))
    assert_equal(payment_filter.program, "@P")
    assert_equal(payment_filter.name, "filters.SuccessfulPayment(['receipt'])")

    assert_equal(Document.ALL.name, "filters.Document.ALL")
    assert_equal(Document.APPLICATION.parameters, "12:application/")
    assert_equal(Document.MP3.parameters, "10:audio/mpeg")
    var custom_category = Document.Category("application/")
    assert_equal(custom_category.name, "filters.Document.Category('application/')")
    var custom_mime = Document.MimeType("image/webp")
    assert_equal(custom_mime.parameters, "10:image/webp")
    var extension = Document.FileExtension(Optional[String]("tar.gz"), True)
    assert_equal(extension.program, "@x")
    assert_equal(extension.parameters, "7:.tar.gz")
    var missing_extension: Optional[String] = None
    var no_extension = Document.FileExtension(missing_extension)
    assert_equal(no_extension.program, "@n")
    assert_equal(no_extension.name, "filters.Document.FileExtension(None)")

    var entity_filter = Entity("mention")
    assert_equal(entity_filter.program, "@E")
    assert_equal(entity_filter.name, "filters.Entity(mention)")
    var caption_entity_filter = CaptionEntity("hashtag")
    assert_equal(caption_entity_filter.program, "@e")
    assert_equal(caption_entity_filter.name, "filters.CaptionEntity(hashtag)")
    var languages = List[String]()
    languages.append("en")
    languages.append("fr")
    var language_filter = Language(languages^)
    assert_equal(language_filter.program, "@L@L|")
    assert_equal(language_filter.name, "filters.Language(['en', 'fr'])")

    var no_exact_texts = List[String]()
    var no_text_filter = Text(Optional[List[String]](no_exact_texts^))
    assert_equal(no_text_filter.program, "?")
    assert_equal(no_text_filter.name, "filters.TEXT")

    var empty_update = Update(update_id=1)
    assert_equal(UPDATE_MESSAGE.check_update(empty_update), False)
