#!/usr/bin/env mojo
#
# Native Mojo Bot configuration translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Bot token, endpoint construction, and cached bot identity."""

from std.collections import List
from std.collections.optional import Optional

from telegram._message import Message
from telegram._passport._crypto import (
    base64_decode,
    rsa_oaep_sha1_decrypt,
    validate_rsa_private_key,
)
from telegram._chatfullinfo import ChatFullInfo
from telegram._chatadministratorrights import ChatAdministratorRights
from telegram._chatinvitelink import ChatInviteLink
from telegram._chatmember import ChatMember
from telegram._chatboost import UserChatBoosts
from telegram._chatpermissions import ChatPermissions
from telegram._botcommand import BotCommand
from telegram._botcommandscope import BotCommandScope
from telegram._botdescription import BotDescription, BotShortDescription
from telegram._botname import BotName
from telegram._files.file import File
from telegram._files.location import Location
from telegram._files.inputfile import InputFile
from telegram._files.inputprofilephoto import InputProfilePhoto
from telegram._files.inputsticker import InputSticker
from telegram._files.inputstorycontent import InputStoryContent
from telegram._files.inputmedia import InputMedia, InputPaidMedia
from telegram._story import Story
from telegram._storyarea import StoryArea
from telegram._messageentity import MessageEntity
from telegram._keyboardbutton import KeyboardButton
from telegram._preparedkeyboardbutton import PreparedKeyboardButton
from telegram._inputchecklist import InputChecklist
from telegram._reply import ReplyParameters
from telegram._forumtopic import ForumTopic
from telegram._messageid import MessageId
from telegram._menubutton import MenuButton
from telegram._poll import InputPollOption, Poll
from telegram._reaction import ReactionType
from telegram._sentwebappmessage import SentWebAppMessage
from telegram._files.sticker import MaskPosition, Sticker, StickerSet
from telegram._gifts import AcceptedGiftTypes, Gift, Gifts
from telegram._sentguestmessage import SentGuestMessage
from telegram._inline.preparedinlinemessage import PreparedInlineMessage
from telegram._games.gamehighscore import GameHighScore
from telegram._payment.stars.staramount import StarAmount
from telegram._payment.stars.startransactions import StarTransactions
from telegram._payment.labeledprice import LabeledPrice
from telegram._update import Update
from telegram._user import User
from telegram._userprofilephotos import UserProfilePhotos
from telegram._userprofileaudios import UserProfileAudios
from telegram._business import BusinessConnection
from telegram._ownedgift import OwnedGifts
from telegram._botaccesssettings import BotAccessSettings
from telegram._webhookinfo import WebhookInfo
from telegram.error import InvalidToken, TelegramError
from telegram._utils.json import JSON_ARRAY, JSON_BOOL, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.files import is_local_file
from telegram._utils.files import ParsedFileInput
from telegram._utils.files import parse_file_input
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.strings import to_camel_case
from telegram.request import HTTPXRequest, RequestData, RequestParameter


def _bot_request_subdocument(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _bot_request_parameters(api_kwargs: Optional[JsonDocument]) raises -> List[RequestParameter]:
    var parameters = List[RequestParameter]()
    if api_kwargs is None:
        return parameters^
    var data = api_kwargs.value().copy()
    if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("Bot api_kwargs must be a JSON object")
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name.copy()
        var value = _bot_request_subdocument(data, child)
        parameters.append(RequestParameter.from_input(key, value))
        child = data.nodes[child].next_sibling
    return parameters^


def _bot_request_data(api_kwargs: Optional[JsonDocument]) raises -> RequestData:
    return RequestData(_bot_request_parameters(api_kwargs))


def _bot_merge_request_parameters(
    parameters: List[RequestParameter],
    api_kwargs: Optional[JsonDocument],
) raises -> List[RequestParameter]:
    var extras = _bot_request_parameters(api_kwargs)
    var result = List[RequestParameter]()
    for parameter in parameters:
        var replaced = False
        for extra in extras:
            if extra.name == parameter.name:
                replaced = True
                break
        if not replaced:
            result.append(parameter.copy())
    for extra in extras:
        result.append(extra.copy())
    return result^


def _bot_parameter_document(parameters: List[RequestParameter]) raises -> JsonDocument:
    var data = RequestData(parameters)
    return data.parameters()


def _bot_merge_api_kwargs(
    data: JsonDocument, api_kwargs: Optional[JsonDocument]
) raises -> JsonDocument:
    var result = data.copy()
    if api_kwargs is None:
        return result^
    var extra = api_kwargs.value().copy()
    if extra.root < 0 or extra.root >= len(extra.nodes) or extra.nodes[extra.root].kind != JSON_OBJECT:
        raise Error("Bot api_kwargs must be a JSON object")
    result.merge_object(result.root, extra, extra.root)
    return result^


def _bot_story_area_array(values: List[StoryArea]) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_array()
    for value in values:
        var item = value.to_dict()
        var child = result.copy_subtree_from(item, item.root)
        result.append_child(result.root, child)
    return result^


def _bot_message_entity_array(values: List[MessageEntity]) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_array()
    for value in values:
        var item = value.to_dict()
        var child = result.copy_subtree_from(item, item.root)
        result.append_child(result.root, child)
    return result^


def _bot_integer_array(values: List[Int]) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_array()
    for value in values:
        var child = result.add_number(String(value))
        result.append_child(result.root, child)
    return result^


def _bot_labeled_price_array(values: List[LabeledPrice]) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.add_array()
    for value in values:
        var item = value.to_dict()
        var child = result.copy_subtree_from(item, item.root)
        result.append_child(result.root, child)
    return result^


def _bot_is_supported_insertion(value: String, start: Int) -> Bool:
    if start < 0 or start >= value.byte_length() or value.as_bytes()[start] != 123:
        return False
    var end = start + 1
    while end < value.byte_length() and value.as_bytes()[end] != 125:
        end += 1
    if end >= value.byte_length():
        return False
    var length = end - start + 1
    if length == 7:
        return (value.as_bytes()[start + 1] == 116 and value.as_bytes()[start + 2] == 111 and value.as_bytes()[start + 3] == 107 and value.as_bytes()[start + 4] == 101 and value.as_bytes()[start + 5] == 110) or (value.as_bytes()[start + 1] == 84 and value.as_bytes()[start + 2] == 79 and value.as_bytes()[start + 3] == 75 and value.as_bytes()[start + 4] == 69 and value.as_bytes()[start + 5] == 78)
    if length == 11:
        var bot_underscore = (value.as_bytes()[start + 1] == 98 and value.as_bytes()[start + 2] == 111 and value.as_bytes()[start + 3] == 116 and value.as_bytes()[start + 4] == 95 and value.as_bytes()[start + 5] == 116 and value.as_bytes()[start + 6] == 111 and value.as_bytes()[start + 7] == 107 and value.as_bytes()[start + 8] == 101 and value.as_bytes()[start + 9] == 110) or (value.as_bytes()[start + 1] == 66 and value.as_bytes()[start + 2] == 79 and value.as_bytes()[start + 3] == 84 and value.as_bytes()[start + 4] == 95 and value.as_bytes()[start + 5] == 84 and value.as_bytes()[start + 6] == 79 and value.as_bytes()[start + 7] == 75 and value.as_bytes()[start + 8] == 69 and value.as_bytes()[start + 9] == 78)
        var bot_hyphen = (value.as_bytes()[start + 1] == 98 and value.as_bytes()[start + 2] == 111 and value.as_bytes()[start + 3] == 116 and value.as_bytes()[start + 4] == 45 and value.as_bytes()[start + 5] == 116 and value.as_bytes()[start + 6] == 111 and value.as_bytes()[start + 7] == 107 and value.as_bytes()[start + 8] == 101 and value.as_bytes()[start + 9] == 110) or (value.as_bytes()[start + 1] == 66 and value.as_bytes()[start + 2] == 79 and value.as_bytes()[start + 3] == 84 and value.as_bytes()[start + 4] == 45 and value.as_bytes()[start + 5] == 84 and value.as_bytes()[start + 6] == 79 and value.as_bytes()[start + 7] == 75 and value.as_bytes()[start + 8] == 69 and value.as_bytes()[start + 9] == 78)
        return bot_underscore or bot_hyphen
    return False


def _bot_append_bytes(mut output: List[UInt8], value: String):
    for byte in value.as_bytes():
        output.append(byte)


def _bot_parse_base_url(value: String, token: String) raises -> String:
    var has_supported = False
    var scan = 0
    while scan < value.byte_length():
        if _bot_is_supported_insertion(value, scan):
            has_supported = True
            break
        scan += 1
    if not has_supported:
        return String(value, token)

    var result = List[UInt8]()
    var index = 0
    while index < value.byte_length():
        if index + 1 < value.byte_length() and value.as_bytes()[index] == 123 and value.as_bytes()[index + 1] == 123:
            result.append(123)
            index += 2
            continue
        if index + 1 < value.byte_length() and value.as_bytes()[index] == 125 and value.as_bytes()[index + 1] == 125:
            result.append(125)
            index += 2
            continue
        if value.as_bytes()[index] == 123:
            if _bot_is_supported_insertion(value, index):
                var end = index + 1
                while value.as_bytes()[end] != 125:
                    end += 1
                _bot_append_bytes(result, token)
                index = end + 1
                continue
            var end = index + 1
            while end < value.byte_length() and value.as_bytes()[end] != 125:
                end += 1
            var insertion_bytes = List[UInt8]()
            for byte_index in range(index + 1, end):
                insertion_bytes.append(value.as_bytes()[byte_index])
            var insertion = String(from_utf8=Span(insertion_bytes))
            raise Error(String("Base URL string contains unsupported insertion: ", insertion))
        if value.as_bytes()[index] == 125:
            raise Error("Base URL string contains an unmatched closing brace")
        result.append(value.as_bytes()[index])
        index += 1
    return String(from_utf8=Span(result))


struct MessageEditResult(Copyable):
    """The Bot API edit-method result: an edited Message or an inline success Boolean."""

    var is_message: Bool
    var message: Optional[Message]
    var success: Bool

    def __init__(out self, message: Message):
        self.is_message = True
        self.message = Optional[Message](message.copy())
        self.success = False

    def __init__(out self, success: Bool):
        self.is_message = False
        self.message = None
        self.success = success

    def __copyinit__(out self, existing: Self):
        self.is_message = existing.is_message
        self.message = existing.message.copy()
        self.success = existing.success

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("MessageEditResult JSON document has no root")
        if data.nodes[data.root].kind == JSON_BOOL:
            return Self(data.boolean_value(data.root))
        return Self(Message.de_json(data))


struct Bot(Copyable):
    """Native Bot core. API transport and endpoint methods are ported separately."""

    var token: String
    var base_url: String
    var base_file_url: String
    var local_mode: Bool
    var private_key: Optional[String]
    var private_key_password: Optional[String]
    var bot_user: Optional[User]
    var request: HTTPXRequest
    var get_updates_request: HTTPXRequest
    var requests_initialized: Bool
    var bot_initialized: Bool

    def __init__(
        out self,
        token: String,
        base_url: String = "https://api.telegram.org/bot",
        base_file_url: String = "https://api.telegram.org/file/bot",
        request: Optional[HTTPXRequest] = None,
        get_updates_request: Optional[HTTPXRequest] = None,
        local_mode: Bool = False,
        private_key: Optional[String] = None,
        private_key_password: Optional[String] = None,
    ) raises:
        if token.byte_length() == 0:
            raise InvalidToken("You must pass the token you received from https://t.me/Botfather!")
        self.token = token.copy()
        self.base_url = _bot_parse_base_url(base_url, token)
        self.base_file_url = _bot_parse_base_url(base_file_url, token)
        self.local_mode = local_mode
        self.private_key = private_key.copy()
        self.private_key_password = private_key_password.copy()
        if self.private_key is not None and not validate_rsa_private_key(
            self.private_key.value(), self.private_key_password
        ):
            raise Error("private_key must contain a valid RSA PEM private key")
        self.bot_user = None
        if request is None:
            self.request = HTTPXRequest()
        else:
            self.request = request.value().copy()
        if get_updates_request is None:
            self.get_updates_request = HTTPXRequest(connection_pool_size=1)
        else:
            self.get_updates_request = get_updates_request.value().copy()
        self.requests_initialized = False
        self.bot_initialized = False

    def __copyinit__(out self, existing: Self):
        self.token = existing.token.copy()
        self.base_url = existing.base_url.copy()
        self.base_file_url = existing.base_file_url.copy()
        self.local_mode = existing.local_mode
        self.private_key = existing.private_key.copy()
        self.private_key_password = existing.private_key_password.copy()
        self.bot_user = existing.bot_user.copy()
        self.request = existing.request.copy()
        self.get_updates_request = existing.get_updates_request.copy()
        self.requests_initialized = existing.requests_initialized
        self.bot_initialized = existing.bot_initialized

    def api_url(self, method: String) -> String:
        return String(self.base_url, "/", method)

    def file_url(self, file_path: String) -> String:
        return String(self.base_file_url, "/", file_path)

    def decrypt_private_secret(self, encrypted_secret: String) raises -> List[UInt8]:
        """Decode Telegram's base64 RSA-OAEP Passport secret using this Bot's key."""
        if self.private_key is None:
            raise Error("A Passport private key must be configured on the Bot")
        return rsa_oaep_sha1_decrypt(
            self.private_key.value(),
            base64_decode(encrypted_secret),
            self.private_key_password,
        )

    def set_bot_user(mut self, user: User):
        self.bot_user = Optional[User](user.copy())
        self.bot_initialized = True

    def do_api_request(
        mut self,
        endpoint: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> JsonDocument:
        var method = to_camel_case(endpoint)
        var parameters = _bot_request_data(api_kwargs)
        return self.request.post(
            self.api_url(method), Optional[RequestData](parameters^)
        )

    def _post_parameters(
        mut self, endpoint: String, parameters: List[RequestParameter]
    ) raises -> JsonDocument:
        var request_data = RequestData(parameters)
        return self.request.post(
            self.api_url(to_camel_case(endpoint)), Optional[RequestData](request_data^)
        )

    def _post_parameters_with_api_kwargs(
        mut self,
        endpoint: String,
        var parameters: List[RequestParameter],
        api_kwargs: Optional[JsonDocument],
    ) raises -> JsonDocument:
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        return self._post_parameters(endpoint, merged^)

    def _post_document(
        mut self, endpoint: String, data: JsonDocument
    ) raises -> JsonDocument:
        var request_data = _bot_request_data(Optional[JsonDocument](data.copy()))
        return self.request.post(
            self.api_url(to_camel_case(endpoint)), Optional[RequestData](request_data^)
        )

    def _post_bool(
        mut self, endpoint: String, parameters: List[RequestParameter]
    ) raises -> Bool:
        var result = self._post_parameters(endpoint, parameters)
        return result.boolean_value(result.root)

    def _post_bool_document(
        mut self, endpoint: String, data: JsonDocument
    ) raises -> Bool:
        var result = self._post_document(endpoint, data)
        return result.boolean_value(result.root)

    def get_me(mut self, api_kwargs: Optional[JsonDocument] = None) raises -> User:
        var result = self.do_api_request("getMe", api_kwargs)
        var user = User.de_json(result)
        self.bot_user = Optional[User](user.copy())
        self.bot_initialized = True
        return user^

    def initialize(mut self) raises:
        if self.requests_initialized and self.bot_initialized:
            return
        if not self.requests_initialized:
            self.get_updates_request.initialize()
            self.request.initialize()
            self.requests_initialized = True
        _ = self.get_me()

    def shutdown(mut self):
        if not self.requests_initialized:
            return
        self.get_updates_request.shutdown()
        self.request.shutdown()
        self.requests_initialized = False
        self.bot_initialized = False

    def send_message(mut self, chat_id: String, text: String) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("text", text))
        var result = self.do_api_request(
            "sendMessage", Optional[JsonDocument](RequestData(parameters).parameters())
        )
        return Message.de_json(result)

    def send_message(mut self, chat_id: Int, text: String) raises -> Message:
        return self.send_message(String(chat_id), text)

    def _post_edit_result(
        mut self,
        endpoint: String,
        var parameters: List[RequestParameter],
        api_kwargs: Optional[JsonDocument],
    ) raises -> MessageEditResult:
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        var result = self._post_parameters(endpoint, merged^)
        return MessageEditResult.de_json(result)

    def edit_message_text(
        mut self,
        text: String,
        chat_id: Optional[String] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        parse_mode: Optional[String] = None,
        entities: Optional[JsonDocument] = None,
        link_preview_options: Optional[JsonDocument] = None,
        disable_web_page_preview: Optional[Bool] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("text", text))
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        if parse_mode is not None:
            parameters.append(RequestParameter.from_input("parse_mode", parse_mode.value()))
        if entities is not None:
            parameters.append(RequestParameter.from_input("entities", entities.value().copy()))
        if link_preview_options is not None:
            parameters.append(RequestParameter.from_input("link_preview_options", link_preview_options.value().copy()))
        if disable_web_page_preview is not None:
            parameters.append(RequestParameter.from_input("disable_web_page_preview", disable_web_page_preview.value()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        return self._post_edit_result("edit_message_text", parameters^, api_kwargs)

    def edit_message_text(
        mut self, text: String, chat_id: Int, message_id: Int,
        parse_mode: Optional[String] = None,
        entities: Optional[JsonDocument] = None,
        link_preview_options: Optional[JsonDocument] = None,
        disable_web_page_preview: Optional[Bool] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        return self.edit_message_text(text, Optional[String](String(chat_id)), Optional[Int](message_id), None, parse_mode, entities, link_preview_options, disable_web_page_preview, reply_markup, business_connection_id, api_kwargs)

    def edit_message_caption(
        mut self,
        chat_id: Optional[String] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[JsonDocument] = None,
        show_caption_above_media: Optional[Bool] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var parameters = List[RequestParameter]()
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        if caption is not None:
            parameters.append(RequestParameter.from_input("caption", caption.value()))
        if parse_mode is not None:
            parameters.append(RequestParameter.from_input("parse_mode", parse_mode.value()))
        if caption_entities is not None:
            parameters.append(RequestParameter.from_input("caption_entities", caption_entities.value().copy()))
        if show_caption_above_media is not None:
            parameters.append(RequestParameter.from_input("show_caption_above_media", show_caption_above_media.value()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        return self._post_edit_result("edit_message_caption", parameters^, api_kwargs)

    def edit_message_reply_markup(
        mut self,
        chat_id: Optional[String] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var parameters = List[RequestParameter]()
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        return self._post_edit_result("edit_message_reply_markup", parameters^, api_kwargs)

    def edit_message_reply_markup(
        mut self, chat_id: Int, message_id: Int,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        return self.edit_message_reply_markup(Optional[String](String(chat_id)), Optional[Int](message_id), None, reply_markup, business_connection_id, api_kwargs)

    def edit_message_media(
        mut self,
        media: JsonDocument,
        chat_id: Optional[String] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var parameters = List[RequestParameter]()
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        parameters.append(RequestParameter.from_input("media", media.copy()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        return self._post_edit_result("edit_message_media", parameters^, api_kwargs)

    def _send_file(
        mut self,
        endpoint: String,
        chat_id: String,
        field_name: String,
        file: InputFile,
        caption: Optional[String],
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input(field_name, file))
        if caption is not None:
            parameters.append(RequestParameter.from_input("caption", caption.value()))
        var result = self._post_parameters_with_api_kwargs(endpoint, parameters^, api_kwargs)
        return Message.de_json(result)

    def _send_file(
        mut self,
        endpoint: String,
        chat_id: String,
        field_name: String,
        file_id: String,
        caption: Optional[String],
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input(field_name, file_id))
        if caption is not None:
            parameters.append(RequestParameter.from_input("caption", caption.value()))
        var result = self._post_parameters_with_api_kwargs(endpoint, parameters^, api_kwargs)
        return Message.de_json(result)

    def send_photo(
        mut self,
        chat_id: String,
        photo: InputFile,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_file("send_photo", chat_id, "photo", photo, caption, api_kwargs)

    def send_photo(
        mut self,
        chat_id: Int,
        photo: InputFile,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_photo(String(chat_id), photo, caption, api_kwargs)

    def send_photo(
        mut self,
        chat_id: String,
        photo_file_id: String,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_file("send_photo", chat_id, "photo", photo_file_id, caption, api_kwargs)

    def send_photo(
        mut self,
        chat_id: Int,
        photo_file_id: String,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_photo(String(chat_id), photo_file_id, caption, api_kwargs)

    def send_document(
        mut self,
        chat_id: String,
        document: InputFile,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_file("send_document", chat_id, "document", document, caption, api_kwargs)

    def send_document(
        mut self,
        chat_id: Int,
        document: InputFile,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_document(String(chat_id), document, caption, api_kwargs)

    def send_document(
        mut self,
        chat_id: String,
        document_file_id: String,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_file(
            "send_document", chat_id, "document", document_file_id, caption, api_kwargs
        )

    def send_document(
        mut self,
        chat_id: Int,
        document_file_id: String,
        caption: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_document(String(chat_id), document_file_id, caption, api_kwargs)

    def send_audio(mut self, chat_id: String, audio: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_audio", chat_id, "audio", audio, caption, api_kwargs)

    def send_audio(mut self, chat_id: Int, audio: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_audio(String(chat_id), audio, caption, api_kwargs)

    def send_audio(mut self, chat_id: String, audio_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_audio", chat_id, "audio", audio_file_id, caption, api_kwargs)

    def send_audio(mut self, chat_id: Int, audio_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_audio(String(chat_id), audio_file_id, caption, api_kwargs)

    def send_sticker(mut self, chat_id: String, sticker: InputFile, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_sticker", chat_id, "sticker", sticker, None, api_kwargs)

    def send_sticker(mut self, chat_id: Int, sticker: InputFile, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_sticker(String(chat_id), sticker, api_kwargs)

    def send_sticker(mut self, chat_id: String, sticker_file_id: String, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_sticker", chat_id, "sticker", sticker_file_id, None, api_kwargs)

    def send_sticker(mut self, chat_id: Int, sticker_file_id: String, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_sticker(String(chat_id), sticker_file_id, api_kwargs)

    def send_video(mut self, chat_id: String, video: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_video", chat_id, "video", video, caption, api_kwargs)

    def send_video(mut self, chat_id: Int, video: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_video(String(chat_id), video, caption, api_kwargs)

    def send_video(mut self, chat_id: String, video_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_video", chat_id, "video", video_file_id, caption, api_kwargs)

    def send_video(mut self, chat_id: Int, video_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_video(String(chat_id), video_file_id, caption, api_kwargs)

    def send_animation(mut self, chat_id: String, animation: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_animation", chat_id, "animation", animation, caption, api_kwargs)

    def send_animation(mut self, chat_id: Int, animation: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_animation(String(chat_id), animation, caption, api_kwargs)

    def send_animation(mut self, chat_id: String, animation_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_animation", chat_id, "animation", animation_file_id, caption, api_kwargs)

    def send_animation(mut self, chat_id: Int, animation_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_animation(String(chat_id), animation_file_id, caption, api_kwargs)

    def send_voice(mut self, chat_id: String, voice: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_voice", chat_id, "voice", voice, caption, api_kwargs)

    def send_voice(mut self, chat_id: Int, voice: InputFile, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_voice(String(chat_id), voice, caption, api_kwargs)

    def send_voice(mut self, chat_id: String, voice_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_voice", chat_id, "voice", voice_file_id, caption, api_kwargs)

    def send_voice(mut self, chat_id: Int, voice_file_id: String, caption: Optional[String] = None, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_voice(String(chat_id), voice_file_id, caption, api_kwargs)

    def send_video_note(mut self, chat_id: String, video_note: InputFile, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_video_note", chat_id, "video_note", video_note, None, api_kwargs)

    def send_video_note(mut self, chat_id: Int, video_note: InputFile, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_video_note(String(chat_id), video_note, api_kwargs)

    def send_video_note(mut self, chat_id: String, video_note_file_id: String, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self._send_file("send_video_note", chat_id, "video_note", video_note_file_id, None, api_kwargs)

    def send_video_note(mut self, chat_id: Int, video_note_file_id: String, api_kwargs: Optional[JsonDocument] = None) raises -> Message:
        return self.send_video_note(String(chat_id), video_note_file_id, api_kwargs)

    def _send_location(
        mut self,
        chat_id: String,
        latitude: Optional[Float64],
        longitude: Optional[Float64],
        horizontal_accuracy: Optional[Float64],
        live_period: Optional[Int],
        heading: Optional[Int],
        proximity_alert_radius: Optional[Int],
        disable_notification: Optional[Bool],
        protect_content: Optional[Bool],
        message_thread_id: Optional[Int],
        direct_messages_topic_id: Optional[Int],
        api_kwargs: Optional[JsonDocument],
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if latitude is not None:
            parameters.append(RequestParameter.from_input("latitude", latitude.value()))
        if longitude is not None:
            parameters.append(RequestParameter.from_input("longitude", longitude.value()))
        if horizontal_accuracy is not None:
            parameters.append(RequestParameter.from_input("horizontal_accuracy", horizontal_accuracy.value()))
        if live_period is not None:
            parameters.append(RequestParameter.from_input("live_period", live_period.value()))
        if heading is not None:
            parameters.append(RequestParameter.from_input("heading", heading.value()))
        if proximity_alert_radius is not None:
            parameters.append(RequestParameter.from_input("proximity_alert_radius", proximity_alert_radius.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("send_location", _bot_merge_api_kwargs(data, api_kwargs))
        return Message.de_json(result)

    def send_location(
        mut self, chat_id: String,
        latitude: Optional[Float64] = None,
        longitude: Optional[Float64] = None,
        horizontal_accuracy: Optional[Float64] = None,
        live_period: Optional[Int] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_location(chat_id, latitude, longitude, horizontal_accuracy, live_period, heading, proximity_alert_radius, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def send_location(
        mut self, chat_id: Int,
        latitude: Optional[Float64] = None,
        longitude: Optional[Float64] = None,
        horizontal_accuracy: Optional[Float64] = None,
        live_period: Optional[Int] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_location(String(chat_id), latitude, longitude, horizontal_accuracy, live_period, heading, proximity_alert_radius, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def _send_venue(
        mut self,
        chat_id: String,
        latitude: Optional[Float64],
        longitude: Optional[Float64],
        title: Optional[String],
        address: Optional[String],
        foursquare_id: Optional[String],
        foursquare_type: Optional[String],
        google_place_id: Optional[String],
        google_place_type: Optional[String],
        disable_notification: Optional[Bool],
        protect_content: Optional[Bool],
        message_thread_id: Optional[Int],
        direct_messages_topic_id: Optional[Int],
        api_kwargs: Optional[JsonDocument],
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if latitude is not None:
            parameters.append(RequestParameter.from_input("latitude", latitude.value()))
        if longitude is not None:
            parameters.append(RequestParameter.from_input("longitude", longitude.value()))
        if title is not None:
            parameters.append(RequestParameter.from_input("title", title.value()))
        if address is not None:
            parameters.append(RequestParameter.from_input("address", address.value()))
        if foursquare_id is not None:
            parameters.append(RequestParameter.from_input("foursquare_id", foursquare_id.value()))
        if foursquare_type is not None:
            parameters.append(RequestParameter.from_input("foursquare_type", foursquare_type.value()))
        if google_place_id is not None:
            parameters.append(RequestParameter.from_input("google_place_id", google_place_id.value()))
        if google_place_type is not None:
            parameters.append(RequestParameter.from_input("google_place_type", google_place_type.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("send_venue", _bot_merge_api_kwargs(data, api_kwargs))
        return Message.de_json(result)

    def send_venue(
        mut self, chat_id: String,
        latitude: Optional[Float64] = None, longitude: Optional[Float64] = None,
        title: Optional[String] = None, address: Optional[String] = None,
        foursquare_id: Optional[String] = None, foursquare_type: Optional[String] = None,
        google_place_id: Optional[String] = None, google_place_type: Optional[String] = None,
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_venue(chat_id, latitude, longitude, title, address, foursquare_id, foursquare_type, google_place_id, google_place_type, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def send_venue(
        mut self, chat_id: Int,
        latitude: Optional[Float64] = None, longitude: Optional[Float64] = None,
        title: Optional[String] = None, address: Optional[String] = None,
        foursquare_id: Optional[String] = None, foursquare_type: Optional[String] = None,
        google_place_id: Optional[String] = None, google_place_type: Optional[String] = None,
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_venue(String(chat_id), latitude, longitude, title, address, foursquare_id, foursquare_type, google_place_id, google_place_type, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def send_contact(
        mut self,
        chat_id: String,
        phone_number: String,
        first_name: String,
        last_name: Optional[String] = None,
        vcard: Optional[String] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("phone_number", phone_number))
        parameters.append(RequestParameter.from_input("first_name", first_name))
        if last_name is not None:
            parameters.append(RequestParameter.from_input("last_name", last_name.value()))
        if vcard is not None:
            parameters.append(RequestParameter.from_input("vcard", vcard.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("send_contact", _bot_merge_api_kwargs(data, api_kwargs))
        return Message.de_json(result)

    def send_contact(
        mut self, chat_id: Int, phone_number: String, first_name: String,
        last_name: Optional[String] = None, vcard: Optional[String] = None,
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_contact(String(chat_id), phone_number, first_name, last_name, vcard, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def send_dice(
        mut self,
        chat_id: String,
        emoji: Optional[String] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if emoji is not None:
            parameters.append(RequestParameter.from_input("emoji", emoji.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("send_dice", _bot_merge_api_kwargs(data, api_kwargs))
        return Message.de_json(result)

    def send_dice(
        mut self, chat_id: Int, emoji: Optional[String] = None,
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_dice(String(chat_id), emoji, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def send_game(
        mut self,
        chat_id: String,
        game_short_name: String,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        business_connection_id: Optional[String] = None,
        message_effect_id: Optional[String] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("game_short_name", game_short_name))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        if message_effect_id is not None:
            parameters.append(RequestParameter.from_input("message_effect_id", message_effect_id.value()))
        if allow_paid_broadcast is not None:
            parameters.append(RequestParameter.from_input("allow_paid_broadcast", allow_paid_broadcast.value()))
        return Message.de_json(self._post_parameters_with_api_kwargs("send_game", parameters^, api_kwargs))

    def send_game(
        mut self, chat_id: Int, game_short_name: String,
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, business_connection_id: Optional[String] = None,
        message_effect_id: Optional[String] = None, allow_paid_broadcast: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_game(String(chat_id), game_short_name, disable_notification, protect_content, message_thread_id, business_connection_id, message_effect_id, allow_paid_broadcast, api_kwargs)

    def send_poll(
        mut self,
        chat_id: String,
        question: String,
        options: List[InputPollOption],
        is_anonymous: Optional[Bool] = None,
        poll_type: Optional[String] = None,
        allows_multiple_answers: Optional[Bool] = None,
        allows_revoting: Optional[Bool] = None,
        allow_adding_options: Optional[Bool] = None,
        hide_results_until_closes: Optional[Bool] = None,
        members_only: Optional[Bool] = None,
        is_closed: Optional[Bool] = None,
        explanation: Optional[String] = None,
        question_parse_mode: Optional[String] = None,
        explanation_parse_mode: Optional[String] = None,
        open_period: Optional[Int] = None,
        close_date: Optional[Int] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        var option_values = JsonDocument()
        option_values.root = option_values.add_array()
        for option in options:
            var item = option.to_dict()
            var child = option_values.copy_subtree_from(item, item.root)
            option_values.append_child(option_values.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("question", question))
        parameters.append(RequestParameter.from_input("options", option_values))
        if is_anonymous is not None:
            parameters.append(RequestParameter.from_input("is_anonymous", is_anonymous.value()))
        if poll_type is not None:
            parameters.append(RequestParameter.from_input("type", poll_type.value()))
        if allows_multiple_answers is not None:
            parameters.append(RequestParameter.from_input("allows_multiple_answers", allows_multiple_answers.value()))
        if allows_revoting is not None:
            parameters.append(RequestParameter.from_input("allows_revoting", allows_revoting.value()))
        if allow_adding_options is not None:
            parameters.append(RequestParameter.from_input("allow_adding_options", allow_adding_options.value()))
        if hide_results_until_closes is not None:
            parameters.append(RequestParameter.from_input("hide_results_until_closes", hide_results_until_closes.value()))
        if members_only is not None:
            parameters.append(RequestParameter.from_input("members_only", members_only.value()))
        if is_closed is not None:
            parameters.append(RequestParameter.from_input("is_closed", is_closed.value()))
        if explanation is not None:
            parameters.append(RequestParameter.from_input("explanation", explanation.value()))
        if question_parse_mode is not None:
            parameters.append(RequestParameter.from_input("question_parse_mode", question_parse_mode.value()))
        if explanation_parse_mode is not None:
            parameters.append(RequestParameter.from_input("explanation_parse_mode", explanation_parse_mode.value()))
        if open_period is not None:
            parameters.append(RequestParameter.from_input("open_period", open_period.value()))
        if close_date is not None:
            parameters.append(RequestParameter.from_input("close_date", close_date.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("send_poll", _bot_merge_api_kwargs(data, api_kwargs))
        return Message.de_json(result)

    def send_poll(
        mut self, chat_id: Int, question: String, options: List[InputPollOption],
        is_anonymous: Optional[Bool] = None, poll_type: Optional[String] = None,
        allows_multiple_answers: Optional[Bool] = None, allows_revoting: Optional[Bool] = None,
        allow_adding_options: Optional[Bool] = None, hide_results_until_closes: Optional[Bool] = None,
        members_only: Optional[Bool] = None, is_closed: Optional[Bool] = None,
        explanation: Optional[String] = None, question_parse_mode: Optional[String] = None,
        explanation_parse_mode: Optional[String] = None, open_period: Optional[Int] = None,
        close_date: Optional[Int] = None, disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None, message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None, api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_poll(String(chat_id), question, options, is_anonymous, poll_type, allows_multiple_answers, allows_revoting, allow_adding_options, hide_results_until_closes, members_only, is_closed, explanation, question_parse_mode, explanation_parse_mode, open_period, close_date, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def stop_poll(
        mut self,
        chat_id: String,
        message_id: Int,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Poll:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("stop_poll", _bot_merge_api_kwargs(data, api_kwargs))
        return Poll.de_json(result)

    def stop_poll(
        mut self, chat_id: Int, message_id: Int,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Poll:
        return self.stop_poll(String(chat_id), message_id, business_connection_id, api_kwargs)

    def delete_message(mut self, chat_id: String, message_id: Int) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        var result = self.do_api_request(
            "delete_message",
            Optional[JsonDocument](_bot_parameter_document(parameters)),
        )
        return result.boolean_value(result.root)

    def delete_message(mut self, chat_id: Int, message_id: Int) raises -> Bool:
        return self.delete_message(String(chat_id), message_id)

    def send_chat_action(
        mut self,
        chat_id: String,
        action: String,
        message_thread_id: Optional[Int] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("action", action))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        return self._post_bool_document(
            "send_chat_action",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def send_chat_action(
        mut self,
        chat_id: Int,
        action: String,
        message_thread_id: Optional[Int] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.send_chat_action(String(chat_id), action, message_thread_id, business_connection_id, api_kwargs)

    def get_chat(mut self, chat_id: String) raises -> ChatFullInfo:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        var result = self.do_api_request(
            "get_chat", Optional[JsonDocument](_bot_parameter_document(parameters))
        )
        return ChatFullInfo.de_json(result)

    def get_chat(mut self, chat_id: Int) raises -> ChatFullInfo:
        return self.get_chat(String(chat_id))

    def get_chat_member_count(mut self, chat_id: String) raises -> Int:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        var result = self.do_api_request(
            "get_chat_member_count",
            Optional[JsonDocument](_bot_parameter_document(parameters)),
        )
        return result.integer_value(result.root)

    def get_chat_member_count(mut self, chat_id: Int) raises -> Int:
        return self.get_chat_member_count(String(chat_id))

    def get_file(mut self, file_id: String) raises -> File:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("file_id", file_id))
        var result = self.do_api_request(
            "get_file", Optional[JsonDocument](_bot_parameter_document(parameters))
        )
        var file_path_index = result.object_get(result.root, "file_path")
        if file_path_index != -1 and not result.is_null(file_path_index):
            var file_path = result.string_value(file_path_index)
            if not is_local_file(file_path):
                result.set_string(result.root, "file_path", self.file_url(file_path))
        return File.de_json(result)

    def get_user_profile_photos(
        mut self,
        user_id: Int,
        offset: Int = 0,
        limit: Int = 100,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> UserProfilePhotos:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("offset", offset))
        parameters.append(RequestParameter.from_input("limit", limit))
        var data = _bot_parameter_document(parameters)
        var merged = _bot_merge_api_kwargs(data, api_kwargs)
        return UserProfilePhotos.de_json(self._post_document("get_user_profile_photos", merged))

    def create_chat_invite_link(
        mut self,
        chat_id: String,
        expire_date: Optional[Int] = None,
        member_limit: Optional[Int] = None,
        name: Optional[String] = None,
        creates_join_request: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if expire_date is not None:
            parameters.append(RequestParameter.from_input("expire_date", expire_date.value()))
        if member_limit is not None:
            parameters.append(RequestParameter.from_input("member_limit", member_limit.value()))
        if name is not None:
            parameters.append(RequestParameter.from_input("name", name.value()))
        if creates_join_request is not None:
            parameters.append(RequestParameter.from_input("creates_join_request", creates_join_request.value()))
        var data = _bot_parameter_document(parameters)
        return ChatInviteLink.de_json(self._post_document("create_chat_invite_link", _bot_merge_api_kwargs(data, api_kwargs)))

    def create_chat_invite_link(
        mut self, chat_id: Int, expire_date: Optional[Int] = None,
        member_limit: Optional[Int] = None, name: Optional[String] = None,
        creates_join_request: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.create_chat_invite_link(String(chat_id), expire_date, member_limit, name, creates_join_request, api_kwargs)

    def edit_chat_invite_link(
        mut self,
        chat_id: String,
        invite_link: String,
        expire_date: Optional[Int] = None,
        member_limit: Optional[Int] = None,
        name: Optional[String] = None,
        creates_join_request: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("invite_link", invite_link))
        if expire_date is not None:
            parameters.append(RequestParameter.from_input("expire_date", expire_date.value()))
        if member_limit is not None:
            parameters.append(RequestParameter.from_input("member_limit", member_limit.value()))
        if name is not None:
            parameters.append(RequestParameter.from_input("name", name.value()))
        if creates_join_request is not None:
            parameters.append(RequestParameter.from_input("creates_join_request", creates_join_request.value()))
        var data = _bot_parameter_document(parameters)
        return ChatInviteLink.de_json(self._post_document("edit_chat_invite_link", _bot_merge_api_kwargs(data, api_kwargs)))

    def edit_chat_invite_link(
        mut self, chat_id: Int, invite_link: String,
        expire_date: Optional[Int] = None, member_limit: Optional[Int] = None,
        name: Optional[String] = None, creates_join_request: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.edit_chat_invite_link(String(chat_id), invite_link, expire_date, member_limit, name, creates_join_request, api_kwargs)

    def edit_chat_invite_link(
        mut self, chat_id: String, invite_link: ChatInviteLink,
        expire_date: Optional[Int] = None, member_limit: Optional[Int] = None,
        name: Optional[String] = None, creates_join_request: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.edit_chat_invite_link(chat_id, invite_link.invite_link, expire_date, member_limit, name, creates_join_request, api_kwargs)

    def revoke_chat_invite_link(
        mut self, chat_id: String, invite_link: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("invite_link", invite_link))
        var data = _bot_parameter_document(parameters)
        return ChatInviteLink.de_json(self._post_document("revoke_chat_invite_link", _bot_merge_api_kwargs(data, api_kwargs)))

    def revoke_chat_invite_link(
        mut self, chat_id: Int, invite_link: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.revoke_chat_invite_link(String(chat_id), invite_link, api_kwargs)

    def revoke_chat_invite_link(
        mut self, chat_id: String, invite_link: ChatInviteLink,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.revoke_chat_invite_link(chat_id, invite_link.invite_link, api_kwargs)

    def approve_chat_join_request(
        mut self, chat_id: String, user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document("approve_chat_join_request", _bot_merge_api_kwargs(data, api_kwargs))

    def approve_chat_join_request(
        mut self, chat_id: Int, user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.approve_chat_join_request(String(chat_id), user_id, api_kwargs)

    def decline_chat_join_request(
        mut self, chat_id: String, user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document("decline_chat_join_request", _bot_merge_api_kwargs(data, api_kwargs))

    def decline_chat_join_request(
        mut self, chat_id: Int, user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.decline_chat_join_request(String(chat_id), user_id, api_kwargs)

    def get_business_connection(
        mut self, business_connection_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> BusinessConnection:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        var data = _bot_parameter_document(parameters)
        return BusinessConnection.de_json(self._post_document("get_business_connection", _bot_merge_api_kwargs(data, api_kwargs)))

    def answer_web_app_query(
        mut self,
        web_app_query_id: String,
        result: JsonDocument,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> SentWebAppMessage:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("web_app_query_id", web_app_query_id))
        parameters.append(RequestParameter.from_input("result", result))
        var data = _bot_parameter_document(parameters)
        return SentWebAppMessage.de_json(self._post_document("answer_web_app_query", _bot_merge_api_kwargs(data, api_kwargs)))

    def save_prepared_inline_message(
        mut self,
        user_id: Int,
        result: JsonDocument,
        allow_user_chats: Optional[Bool] = None,
        allow_bot_chats: Optional[Bool] = None,
        allow_group_chats: Optional[Bool] = None,
        allow_channel_chats: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> PreparedInlineMessage:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("result", result))
        if allow_user_chats is not None:
            parameters.append(RequestParameter.from_input("allow_user_chats", allow_user_chats.value()))
        if allow_bot_chats is not None:
            parameters.append(RequestParameter.from_input("allow_bot_chats", allow_bot_chats.value()))
        if allow_group_chats is not None:
            parameters.append(RequestParameter.from_input("allow_group_chats", allow_group_chats.value()))
        if allow_channel_chats is not None:
            parameters.append(RequestParameter.from_input("allow_channel_chats", allow_channel_chats.value()))
        var data = _bot_parameter_document(parameters)
        return PreparedInlineMessage.de_json(self._post_document("save_prepared_inline_message", _bot_merge_api_kwargs(data, api_kwargs)))

    def get_my_default_administrator_rights(
        mut self,
        for_channels: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatAdministratorRights:
        var parameters = List[RequestParameter]()
        if for_channels is not None:
            parameters.append(RequestParameter.from_input("for_channels", for_channels.value()))
        var data = _bot_parameter_document(parameters)
        return ChatAdministratorRights.de_json(self._post_document("get_my_default_administrator_rights", _bot_merge_api_kwargs(data, api_kwargs)))

    def set_my_default_administrator_rights(
        mut self,
        rights: Optional[ChatAdministratorRights] = None,
        for_channels: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if rights is not None:
            parameters.append(RequestParameter.from_input("rights", rights.value().to_dict()))
        if for_channels is not None:
            parameters.append(RequestParameter.from_input("for_channels", for_channels.value()))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document("set_my_default_administrator_rights", _bot_merge_api_kwargs(data, api_kwargs))

    def create_forum_topic(
        mut self, chat_id: String, name: String,
        icon_color: Optional[Int] = None,
        icon_custom_emoji_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ForumTopic:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("name", name))
        if icon_color is not None:
            parameters.append(RequestParameter.from_input("icon_color", icon_color.value()))
        if icon_custom_emoji_id is not None:
            parameters.append(RequestParameter.from_input("icon_custom_emoji_id", icon_custom_emoji_id.value()))
        var data = _bot_parameter_document(parameters)
        return ForumTopic.de_json(self._post_document("create_forum_topic", _bot_merge_api_kwargs(data, api_kwargs)))

    def create_forum_topic(
        mut self, chat_id: Int, name: String,
        icon_color: Optional[Int] = None,
        icon_custom_emoji_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ForumTopic:
        return self.create_forum_topic(String(chat_id), name, icon_color, icon_custom_emoji_id, api_kwargs)

    def edit_forum_topic(
        mut self, chat_id: String, message_thread_id: Int,
        name: Optional[String] = None,
        icon_custom_emoji_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id))
        if name is not None:
            parameters.append(RequestParameter.from_input("name", name.value()))
        if icon_custom_emoji_id is not None:
            parameters.append(RequestParameter.from_input("icon_custom_emoji_id", icon_custom_emoji_id.value()))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document("edit_forum_topic", _bot_merge_api_kwargs(data, api_kwargs))

    def edit_forum_topic(
        mut self, chat_id: Int, message_thread_id: Int,
        name: Optional[String] = None,
        icon_custom_emoji_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.edit_forum_topic(String(chat_id), message_thread_id, name, icon_custom_emoji_id, api_kwargs)

    def _forum_topic_action(
        mut self, endpoint: String, chat_id: String, message_thread_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document(endpoint, _bot_merge_api_kwargs(data, api_kwargs))

    def close_forum_topic(mut self, chat_id: String, message_thread_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self._forum_topic_action("close_forum_topic", chat_id, message_thread_id, api_kwargs)

    def close_forum_topic(mut self, chat_id: Int, message_thread_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.close_forum_topic(String(chat_id), message_thread_id, api_kwargs)

    def reopen_forum_topic(mut self, chat_id: String, message_thread_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self._forum_topic_action("reopen_forum_topic", chat_id, message_thread_id, api_kwargs)

    def reopen_forum_topic(mut self, chat_id: Int, message_thread_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.reopen_forum_topic(String(chat_id), message_thread_id, api_kwargs)

    def delete_forum_topic(mut self, chat_id: String, message_thread_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self._forum_topic_action("delete_forum_topic", chat_id, message_thread_id, api_kwargs)

    def delete_forum_topic(mut self, chat_id: Int, message_thread_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.delete_forum_topic(String(chat_id), message_thread_id, api_kwargs)

    def set_webhook(
        mut self,
        url: String,
        certificate: Optional[InputFile] = None,
        max_connections: Optional[Int] = None,
        allowed_updates: Optional[List[String]] = None,
        ip_address: Optional[String] = None,
        drop_pending_updates: Optional[Bool] = None,
        secret_token: Optional[String] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("url", url))
        if certificate is not None:
            parameters.append(
                RequestParameter.from_input("certificate", certificate.value().copy())
            )
        if max_connections is not None:
            parameters.append(
                RequestParameter.from_input("max_connections", max_connections.value())
            )
        if allowed_updates is not None:
            var updates = JsonDocument()
            updates.root = updates.add_array()
            for item in allowed_updates.value():
                var child = updates.add_string(item.copy())
                updates.append_child(updates.root, child)
            parameters.append(RequestParameter.from_input("allowed_updates", updates))
        if ip_address is not None:
            parameters.append(RequestParameter.from_input("ip_address", ip_address.value()))
        if drop_pending_updates is not None:
            parameters.append(
                RequestParameter.from_input("drop_pending_updates", drop_pending_updates.value())
            )
        if secret_token is not None:
            parameters.append(RequestParameter.from_input("secret_token", secret_token.value()))
        return self._post_bool("set_webhook", parameters)

    def delete_webhook(
        mut self, drop_pending_updates: Optional[Bool] = None
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if drop_pending_updates is not None:
            parameters.append(
                RequestParameter.from_input("drop_pending_updates", drop_pending_updates.value())
            )
        return self._post_bool("delete_webhook", parameters)

    def get_webhook_info(mut self) raises -> WebhookInfo:
        var result = self._post_parameters("get_webhook_info", List[RequestParameter]())
        return WebhookInfo.de_json(result)

    def get_updates(
        mut self,
        offset: Optional[Int] = None,
        limit: Optional[Int] = None,
        timeout: Optional[Int] = None,
        allowed_updates: Optional[List[String]] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[Update]:
        var parameters = List[RequestParameter]()
        if offset is not None:
            parameters.append(RequestParameter.from_input("offset", offset.value()))
        if limit is not None:
            parameters.append(RequestParameter.from_input("limit", limit.value()))
        if timeout is not None:
            parameters.append(RequestParameter.from_input("timeout", timeout.value()))
        if allowed_updates is not None:
            var updates = JsonDocument()
            updates.root = updates.add_array()
            for item in allowed_updates.value():
                var child = updates.add_string(item.copy())
                updates.append_child(updates.root, child)
            parameters.append(RequestParameter.from_input("allowed_updates", updates))
        var base_data = _bot_parameter_document(parameters)
        var all_data = _bot_merge_api_kwargs(base_data, api_kwargs)
        var request_data = _bot_request_data(Optional[JsonDocument](all_data.copy()))
        var response = self.get_updates_request.post(
            self.api_url("getUpdates"), Optional[RequestData](request_data^)
        )
        return Update.de_list(response, response.root)

    def answer_callback_query(
        mut self,
        callback_query_id: String,
        text: Optional[String] = None,
        show_alert: Optional[Bool] = None,
        url: Optional[String] = None,
        cache_time: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(
            RequestParameter.from_input("callback_query_id", callback_query_id)
        )
        if text is not None:
            parameters.append(RequestParameter.from_input("text", text.value()))
        if show_alert is not None:
            parameters.append(RequestParameter.from_input("show_alert", show_alert.value()))
        if url is not None:
            parameters.append(RequestParameter.from_input("url", url.value()))
        if cache_time is not None:
            parameters.append(RequestParameter.from_input("cache_time", cache_time.value()))
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("answer_callback_query", data)

    def answer_inline_query(
        mut self,
        inline_query_id: String,
        results: JsonDocument,
        cache_time: Optional[Int] = None,
        is_personal: Optional[Bool] = None,
        next_offset: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("inline_query_id", inline_query_id))
        parameters.append(RequestParameter.from_input("results", results))
        if cache_time is not None:
            parameters.append(RequestParameter.from_input("cache_time", cache_time.value()))
        if is_personal is not None:
            parameters.append(RequestParameter.from_input("is_personal", is_personal.value()))
        if next_offset is not None:
            parameters.append(RequestParameter.from_input("next_offset", next_offset.value()))
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("answer_inline_query", data)

    def answer_shipping_query(
        mut self,
        shipping_query_id: String,
        ok: Bool,
        shipping_options: Optional[JsonDocument] = None,
        error_message: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("shipping_query_id", shipping_query_id))
        parameters.append(RequestParameter.from_input("ok", ok))
        if shipping_options is not None:
            parameters.append(
                RequestParameter.from_input("shipping_options", shipping_options.value().copy())
            )
        if error_message is not None:
            parameters.append(
                RequestParameter.from_input("error_message", error_message.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("answer_shipping_query", data)

    def answer_pre_checkout_query(
        mut self,
        pre_checkout_query_id: String,
        ok: Bool,
        error_message: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(
            RequestParameter.from_input("pre_checkout_query_id", pre_checkout_query_id)
        )
        parameters.append(RequestParameter.from_input("ok", ok))
        if error_message is not None:
            parameters.append(
                RequestParameter.from_input("error_message", error_message.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("answer_pre_checkout_query", data)

    def get_my_commands(
        mut self,
        scope: Optional[BotCommandScope] = None,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[BotCommand]:
        var parameters = List[RequestParameter]()
        if scope is not None:
            parameters.append(RequestParameter.from_input("scope", scope.value().to_dict()))
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        var response = self._post_document("get_my_commands", data)
        return BotCommand.de_list(response, response.root)

    def set_my_commands(
        mut self,
        commands: List[BotCommand],
        scope: Optional[BotCommandScope] = None,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var command_array = JsonDocument()
        command_array.root = command_array.add_array()
        for command in commands:
            var command_data = command.to_dict()
            var child = command_array.copy_subtree_from(command_data, command_data.root)
            command_array.append_child(command_array.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("commands", command_array))
        if scope is not None:
            parameters.append(RequestParameter.from_input("scope", scope.value().to_dict()))
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("set_my_commands", data)

    def delete_my_commands(
        mut self,
        scope: Optional[BotCommandScope] = None,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if scope is not None:
            parameters.append(RequestParameter.from_input("scope", scope.value().to_dict()))
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("delete_my_commands", data)

    def set_chat_menu_button(
        mut self,
        chat_id: Optional[Int] = None,
        menu_button: Optional[MenuButton] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if menu_button is not None:
            parameters.append(
                RequestParameter.from_input("menu_button", menu_button.value().to_dict())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("set_chat_menu_button", data)

    def get_chat_menu_button(
        mut self,
        chat_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MenuButton:
        var parameters = List[RequestParameter]()
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        var result = self._post_document("get_chat_menu_button", data)
        return MenuButton.de_json(result)

    def set_my_description(
        mut self,
        description: Optional[String] = None,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if description is not None:
            parameters.append(RequestParameter.from_input("description", description.value()))
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("set_my_description", data)

    def set_my_short_description(
        mut self,
        short_description: Optional[String] = None,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if short_description is not None:
            parameters.append(
                RequestParameter.from_input("short_description", short_description.value())
            )
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("set_my_short_description", data)

    def get_my_description(
        mut self,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> BotDescription:
        var parameters = List[RequestParameter]()
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return BotDescription.de_json(self._post_document("get_my_description", data))

    def get_my_short_description(
        mut self,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> BotShortDescription:
        var parameters = List[RequestParameter]()
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return BotShortDescription.de_json(
            self._post_document("get_my_short_description", data)
        )

    def set_my_name(
        mut self,
        name: Optional[String] = None,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if name is not None:
            parameters.append(RequestParameter.from_input("name", name.value()))
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return self._post_bool_document("set_my_name", data)

    def get_my_name(
        mut self,
        language_code: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> BotName:
        var parameters = List[RequestParameter]()
        if language_code is not None:
            parameters.append(
                RequestParameter.from_input("language_code", language_code.value())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        return BotName.de_json(self._post_document("get_my_name", data))

    def leave_chat(mut self, chat_id: String) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        return self._post_bool("leave_chat", parameters)

    def leave_chat(mut self, chat_id: Int) raises -> Bool:
        return self.leave_chat(String(chat_id))

    def set_chat_title(
        mut self, chat_id: String, title: String
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("title", title))
        return self._post_bool("set_chat_title", parameters)

    def set_chat_title(mut self, chat_id: Int, title: String) raises -> Bool:
        return self.set_chat_title(String(chat_id), title)

    def set_chat_photo(
        mut self, chat_id: String, photo: InputFile,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("photo", photo))
        var result = self._post_parameters_with_api_kwargs("set_chat_photo", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def set_chat_photo(
        mut self, chat_id: Int, photo: InputFile,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_chat_photo(String(chat_id), photo, api_kwargs)

    def delete_chat_photo(mut self, chat_id: String, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        var result = self._post_parameters_with_api_kwargs("delete_chat_photo", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def delete_chat_photo(mut self, chat_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.delete_chat_photo(String(chat_id), api_kwargs)

    def set_chat_sticker_set(
        mut self, chat_id: String, sticker_set_name: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("sticker_set_name", sticker_set_name))
        var result = self._post_parameters_with_api_kwargs("set_chat_sticker_set", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def set_chat_sticker_set(
        mut self, chat_id: Int, sticker_set_name: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_chat_sticker_set(String(chat_id), sticker_set_name, api_kwargs)

    def delete_chat_sticker_set(mut self, chat_id: String, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        var result = self._post_parameters_with_api_kwargs("delete_chat_sticker_set", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def delete_chat_sticker_set(mut self, chat_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.delete_chat_sticker_set(String(chat_id), api_kwargs)

    def unpin_all_chat_messages(mut self, chat_id: String, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        var result = self._post_parameters_with_api_kwargs("unpin_all_chat_messages", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def unpin_all_chat_messages(mut self, chat_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.unpin_all_chat_messages(String(chat_id), api_kwargs)

    def log_out(mut self, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        var result = self.do_api_request("log_out", api_kwargs)
        return result.boolean_value(result.root)

    def close(mut self, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        var result = self.do_api_request("close", api_kwargs)
        return result.boolean_value(result.root)

    def set_chat_description(
        mut self, chat_id: String, description: Optional[String] = None
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if description is not None:
            parameters.append(
                RequestParameter.from_input("description", description.value())
            )
        return self._post_bool("set_chat_description", parameters)

    def set_chat_description(
        mut self, chat_id: Int, description: Optional[String] = None
    ) raises -> Bool:
        return self.set_chat_description(String(chat_id), description)

    def set_chat_permissions(
        mut self,
        chat_id: String,
        permissions: ChatPermissions,
        use_independent_chat_permissions: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(
            RequestParameter.from_input("permissions", permissions.to_dict())
        )
        if use_independent_chat_permissions is not None:
            parameters.append(
                RequestParameter.from_input(
                    "use_independent_chat_permissions",
                    use_independent_chat_permissions.value(),
                )
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        var result = self._post_document("set_chat_permissions", data)
        return result.boolean_value(result.root)

    def set_chat_permissions(
        mut self,
        chat_id: Int,
        permissions: ChatPermissions,
        use_independent_chat_permissions: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_chat_permissions(
            String(chat_id), permissions, use_independent_chat_permissions, api_kwargs
        )

    def set_chat_administrator_custom_title(
        mut self, chat_id: String, user_id: Int, custom_title: String
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("custom_title", custom_title))
        return self._post_bool("set_chat_administrator_custom_title", parameters)

    def set_chat_administrator_custom_title(
        mut self, chat_id: Int, user_id: Int, custom_title: String
    ) raises -> Bool:
        return self.set_chat_administrator_custom_title(
            String(chat_id), user_id, custom_title
        )

    def export_chat_invite_link(mut self, chat_id: String) raises -> String:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        var result = self._post_parameters("export_chat_invite_link", parameters)
        return result.string_value(result.root)

    def export_chat_invite_link(mut self, chat_id: Int) raises -> String:
        return self.export_chat_invite_link(String(chat_id))

    def send_message_draft(
        mut self,
        chat_id: Int,
        draft_id: Int,
        text: Optional[String] = None,
        message_thread_id: Optional[Int] = None,
        parse_mode: Optional[String] = None,
        entities: Optional[JsonDocument] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("draft_id", draft_id))
        if text is not None:
            parameters.append(RequestParameter.from_input("text", text.value()))
        if message_thread_id is not None:
            parameters.append(
                RequestParameter.from_input("message_thread_id", message_thread_id.value())
            )
        if parse_mode is not None:
            parameters.append(RequestParameter.from_input("parse_mode", parse_mode.value()))
        if entities is not None:
            parameters.append(
                RequestParameter.from_input("entities", entities.value().copy())
            )
        var data = _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        var result = self._post_document("send_message_draft", data)
        return result.boolean_value(result.root)

    def pin_chat_message(
        mut self,
        chat_id: String,
        message_id: Int,
        disable_notification: Optional[Bool] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        if disable_notification is not None:
            parameters.append(
                RequestParameter.from_input(
                    "disable_notification", disable_notification.value()
                )
            )
        return self._post_bool("pin_chat_message", parameters)

    def pin_chat_message(
        mut self,
        chat_id: Int,
        message_id: Int,
        disable_notification: Optional[Bool] = None,
    ) raises -> Bool:
        return self.pin_chat_message(String(chat_id), message_id, disable_notification)

    def unpin_chat_message(
        mut self, chat_id: String, message_id: Optional[Int] = None
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        return self._post_bool("unpin_chat_message", parameters)

    def unpin_chat_message(
        mut self, chat_id: Int, message_id: Optional[Int] = None
    ) raises -> Bool:
        return self.unpin_chat_message(String(chat_id), message_id)

    def get_chat_member(
        mut self, chat_id: String, user_id: Int
    ) raises -> ChatMember:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        var result = self._post_parameters("get_chat_member", parameters)
        return ChatMember.de_json(result)

    def get_chat_member(mut self, chat_id: Int, user_id: Int) raises -> ChatMember:
        return self.get_chat_member(String(chat_id), user_id)

    def get_chat_administrators(mut self, chat_id: String) raises -> List[ChatMember]:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        var result = self._post_parameters("get_chat_administrators", parameters)
        return ChatMember.de_list(result, result.root)

    def get_chat_administrators(mut self, chat_id: Int) raises -> List[ChatMember]:
        return self.get_chat_administrators(String(chat_id))

    def ban_chat_member(
        mut self,
        chat_id: String,
        user_id: Int,
        until_date: Optional[Int] = None,
        revoke_messages: Optional[Bool] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if until_date is not None:
            parameters.append(RequestParameter.from_input("until_date", until_date.value()))
        if revoke_messages is not None:
            parameters.append(
                RequestParameter.from_input("revoke_messages", revoke_messages.value())
            )
        return self._post_bool("ban_chat_member", parameters)

    def ban_chat_member(
        mut self,
        chat_id: Int,
        user_id: Int,
        until_date: Optional[Int] = None,
        revoke_messages: Optional[Bool] = None,
    ) raises -> Bool:
        return self.ban_chat_member(String(chat_id), user_id, until_date, revoke_messages)

    def unban_chat_member(
        mut self,
        chat_id: String,
        user_id: Int,
        only_if_banned: Optional[Bool] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if only_if_banned is not None:
            parameters.append(
                RequestParameter.from_input("only_if_banned", only_if_banned.value())
            )
        return self._post_bool("unban_chat_member", parameters)

    def unban_chat_member(
        mut self,
        chat_id: Int,
        user_id: Int,
        only_if_banned: Optional[Bool] = None,
    ) raises -> Bool:
        return self.unban_chat_member(String(chat_id), user_id, only_if_banned)

    def ban_chat_sender_chat(mut self, chat_id: String, sender_chat_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("sender_chat_id", sender_chat_id))
        var result = self._post_parameters_with_api_kwargs("ban_chat_sender_chat", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def ban_chat_sender_chat(mut self, chat_id: Int, sender_chat_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.ban_chat_sender_chat(String(chat_id), sender_chat_id, api_kwargs)

    def unban_chat_sender_chat(mut self, chat_id: String, sender_chat_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("sender_chat_id", sender_chat_id))
        var result = self._post_parameters_with_api_kwargs("unban_chat_sender_chat", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def unban_chat_sender_chat(mut self, chat_id: Int, sender_chat_id: Int, api_kwargs: Optional[JsonDocument] = None) raises -> Bool:
        return self.unban_chat_sender_chat(String(chat_id), sender_chat_id, api_kwargs)

    def promote_chat_member(
        mut self, chat_id: String, user_id: Int,
        can_change_info: Optional[Bool] = None, can_post_messages: Optional[Bool] = None,
        can_edit_messages: Optional[Bool] = None, can_delete_messages: Optional[Bool] = None,
        can_invite_users: Optional[Bool] = None, can_restrict_members: Optional[Bool] = None,
        can_pin_messages: Optional[Bool] = None, can_promote_members: Optional[Bool] = None,
        is_anonymous: Optional[Bool] = None, can_manage_chat: Optional[Bool] = None,
        can_manage_video_chats: Optional[Bool] = None, can_manage_topics: Optional[Bool] = None,
        can_post_stories: Optional[Bool] = None, can_edit_stories: Optional[Bool] = None,
        can_delete_stories: Optional[Bool] = None, can_manage_direct_messages: Optional[Bool] = None,
        can_manage_tags: Optional[Bool] = None, api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if can_change_info is not None: parameters.append(RequestParameter.from_input("can_change_info", can_change_info.value()))
        if can_post_messages is not None: parameters.append(RequestParameter.from_input("can_post_messages", can_post_messages.value()))
        if can_edit_messages is not None: parameters.append(RequestParameter.from_input("can_edit_messages", can_edit_messages.value()))
        if can_delete_messages is not None: parameters.append(RequestParameter.from_input("can_delete_messages", can_delete_messages.value()))
        if can_invite_users is not None: parameters.append(RequestParameter.from_input("can_invite_users", can_invite_users.value()))
        if can_restrict_members is not None: parameters.append(RequestParameter.from_input("can_restrict_members", can_restrict_members.value()))
        if can_pin_messages is not None: parameters.append(RequestParameter.from_input("can_pin_messages", can_pin_messages.value()))
        if can_promote_members is not None: parameters.append(RequestParameter.from_input("can_promote_members", can_promote_members.value()))
        if is_anonymous is not None: parameters.append(RequestParameter.from_input("is_anonymous", is_anonymous.value()))
        if can_manage_chat is not None: parameters.append(RequestParameter.from_input("can_manage_chat", can_manage_chat.value()))
        if can_manage_video_chats is not None: parameters.append(RequestParameter.from_input("can_manage_video_chats", can_manage_video_chats.value()))
        if can_manage_topics is not None: parameters.append(RequestParameter.from_input("can_manage_topics", can_manage_topics.value()))
        if can_post_stories is not None: parameters.append(RequestParameter.from_input("can_post_stories", can_post_stories.value()))
        if can_edit_stories is not None: parameters.append(RequestParameter.from_input("can_edit_stories", can_edit_stories.value()))
        if can_delete_stories is not None: parameters.append(RequestParameter.from_input("can_delete_stories", can_delete_stories.value()))
        if can_manage_direct_messages is not None: parameters.append(RequestParameter.from_input("can_manage_direct_messages", can_manage_direct_messages.value()))
        if can_manage_tags is not None: parameters.append(RequestParameter.from_input("can_manage_tags", can_manage_tags.value()))
        var result = self._post_parameters_with_api_kwargs("promote_chat_member", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def promote_chat_member(
        mut self, chat_id: Int, user_id: Int,
        can_change_info: Optional[Bool] = None, can_post_messages: Optional[Bool] = None,
        can_edit_messages: Optional[Bool] = None, can_delete_messages: Optional[Bool] = None,
        can_invite_users: Optional[Bool] = None, can_restrict_members: Optional[Bool] = None,
        can_pin_messages: Optional[Bool] = None, can_promote_members: Optional[Bool] = None,
        is_anonymous: Optional[Bool] = None, can_manage_chat: Optional[Bool] = None,
        can_manage_video_chats: Optional[Bool] = None, can_manage_topics: Optional[Bool] = None,
        can_post_stories: Optional[Bool] = None, can_edit_stories: Optional[Bool] = None,
        can_delete_stories: Optional[Bool] = None, can_manage_direct_messages: Optional[Bool] = None,
        can_manage_tags: Optional[Bool] = None, api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.promote_chat_member(String(chat_id), user_id, can_change_info, can_post_messages, can_edit_messages, can_delete_messages, can_invite_users, can_restrict_members, can_pin_messages, can_promote_members, is_anonymous, can_manage_chat, can_manage_video_chats, can_manage_topics, can_post_stories, can_edit_stories, can_delete_stories, can_manage_direct_messages, can_manage_tags, api_kwargs)

    def restrict_chat_member(
        mut self,
        chat_id: String,
        user_id: Int,
        permissions: ChatPermissions,
        until_date: Optional[Int] = None,
        use_independent_chat_permissions: Optional[Bool] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("permissions", permissions.to_dict()))
        if until_date is not None:
            parameters.append(RequestParameter.from_input("until_date", until_date.value()))
        if use_independent_chat_permissions is not None:
            parameters.append(
                RequestParameter.from_input(
                    "use_independent_chat_permissions",
                    use_independent_chat_permissions.value(),
                )
            )
        return self._post_bool("restrict_chat_member", parameters)

    def restrict_chat_member(
        mut self,
        chat_id: Int,
        user_id: Int,
        permissions: ChatPermissions,
        until_date: Optional[Int] = None,
        use_independent_chat_permissions: Optional[Bool] = None,
    ) raises -> Bool:
        return self.restrict_chat_member(
            String(chat_id),
            user_id,
            permissions,
            until_date,
            use_independent_chat_permissions,
        )

    def delete_messages(
        mut self, chat_id: String, message_ids: List[Int]
    ) raises -> Bool:
        var messages = JsonDocument()
        messages.root = messages.add_array()
        for message_id in message_ids:
            var child = messages.add_number(String(message_id))
            messages.append_child(messages.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_ids", messages))
        var result = self._post_parameters("delete_messages", parameters)
        return result.boolean_value(result.root)

    def delete_messages(
        mut self, chat_id: Int, message_ids: List[Int]
    ) raises -> Bool:
        return self.delete_messages(String(chat_id), message_ids)

    def _set_message_reaction(
        mut self,
        chat_id: String,
        message_id: Int,
        reaction: Optional[JsonDocument],
        is_big: Optional[Bool],
        api_kwargs: Optional[JsonDocument],
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        if reaction is not None:
            parameters.append(RequestParameter.from_input("reaction", reaction.value()))
        if is_big is not None:
            parameters.append(RequestParameter.from_input("is_big", is_big.value()))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document("set_message_reaction", _bot_merge_api_kwargs(data, api_kwargs))

    def set_message_reaction(
        mut self, chat_id: String, message_id: Int,
        reaction: Optional[JsonDocument] = None,
        is_big: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self._set_message_reaction(chat_id, message_id, reaction, is_big, api_kwargs)

    def set_message_reaction(
        mut self, chat_id: Int, message_id: Int,
        reaction: Optional[JsonDocument] = None,
        is_big: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self._set_message_reaction(String(chat_id), message_id, reaction, is_big, api_kwargs)

    def set_message_reaction(
        mut self, chat_id: String, message_id: Int,
        reaction: String,
        is_big: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var array = JsonDocument()
        array.root = array.add_array()
        var child = array.add_string(reaction)
        array.append_child(array.root, child)
        return self._set_message_reaction(chat_id, message_id, Optional[JsonDocument](array^), is_big, api_kwargs)

    def set_message_reaction(
        mut self, chat_id: Int, message_id: Int,
        reaction: String,
        is_big: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_message_reaction(String(chat_id), message_id, reaction, is_big, api_kwargs)

    def set_message_reaction(
        mut self, chat_id: String, message_id: Int,
        reaction: ReactionType,
        is_big: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var array = JsonDocument()
        array.root = array.add_array()
        var item = reaction.to_dict()
        var child = array.copy_subtree_from(item, item.root)
        array.append_child(array.root, child)
        return self._set_message_reaction(chat_id, message_id, Optional[JsonDocument](array^), is_big, api_kwargs)

    def set_message_reaction(
        mut self, chat_id: Int, message_id: Int,
        reaction: ReactionType,
        is_big: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_message_reaction(String(chat_id), message_id, reaction, is_big, api_kwargs)

    def set_message_reaction(
        mut self, chat_id: String, message_id: Int,
        reaction: List[ReactionType],
        is_big: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var array = JsonDocument()
        array.root = array.add_array()
        for item in reaction:
            var value = item.to_dict()
            var child = array.copy_subtree_from(value, value.root)
            array.append_child(array.root, child)
        return self._set_message_reaction(chat_id, message_id, Optional[JsonDocument](array^), is_big, api_kwargs)

    def delete_message_reaction(
        mut self, chat_id: String, message_id: Int,
        user_id: Optional[Int] = None,
        actor_chat_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        if user_id is not None:
            parameters.append(RequestParameter.from_input("user_id", user_id.value()))
        if actor_chat_id is not None:
            parameters.append(RequestParameter.from_input("actor_chat_id", actor_chat_id.value()))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document("delete_message_reaction", _bot_merge_api_kwargs(data, api_kwargs))

    def delete_message_reaction(
        mut self, chat_id: Int, message_id: Int,
        user_id: Optional[Int] = None, actor_chat_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.delete_message_reaction(String(chat_id), message_id, user_id, actor_chat_id, api_kwargs)

    def delete_all_message_reactions(
        mut self, chat_id: String,
        user_id: Optional[Int] = None,
        actor_chat_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if user_id is not None:
            parameters.append(RequestParameter.from_input("user_id", user_id.value()))
        if actor_chat_id is not None:
            parameters.append(RequestParameter.from_input("actor_chat_id", actor_chat_id.value()))
        var data = _bot_parameter_document(parameters)
        return self._post_bool_document("delete_all_message_reactions", _bot_merge_api_kwargs(data, api_kwargs))

    def delete_all_message_reactions(
        mut self, chat_id: Int,
        user_id: Optional[Int] = None, actor_chat_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.delete_all_message_reactions(String(chat_id), user_id, actor_chat_id, api_kwargs)

    def forward_messages(
        mut self,
        chat_id: String,
        from_chat_id: String,
        message_ids: List[Int],
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        var ids = JsonDocument()
        ids.root = ids.add_array()
        for message_id in message_ids:
            var child = ids.add_number(String(message_id))
            ids.append_child(ids.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("from_chat_id", from_chat_id))
        parameters.append(RequestParameter.from_input("message_ids", ids))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("forward_messages", _bot_merge_api_kwargs(data, api_kwargs))
        return MessageId.de_list(result, result.root)

    def forward_messages(
        mut self, chat_id: Int, from_chat_id: String, message_ids: List[Int],
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        return self.forward_messages(String(chat_id), from_chat_id, message_ids, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def forward_messages(
        mut self, chat_id: String, from_chat_id: Int, message_ids: List[Int],
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        return self.forward_messages(chat_id, String(from_chat_id), message_ids, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def forward_messages(
        mut self, chat_id: Int, from_chat_id: Int, message_ids: List[Int],
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        return self.forward_messages(String(chat_id), String(from_chat_id), message_ids, disable_notification, protect_content, message_thread_id, direct_messages_topic_id, api_kwargs)

    def copy_messages(
        mut self,
        chat_id: String,
        from_chat_id: String,
        message_ids: List[Int],
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        remove_caption: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        var ids = JsonDocument()
        ids.root = ids.add_array()
        for message_id in message_ids:
            var child = ids.add_number(String(message_id))
            ids.append_child(ids.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("from_chat_id", from_chat_id))
        parameters.append(RequestParameter.from_input("message_ids", ids))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if remove_caption is not None:
            parameters.append(RequestParameter.from_input("remove_caption", remove_caption.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var data = _bot_parameter_document(parameters)
        var result = self._post_document("copy_messages", _bot_merge_api_kwargs(data, api_kwargs))
        return MessageId.de_list(result, result.root)

    def copy_messages(
        mut self, chat_id: Int, from_chat_id: String, message_ids: List[Int],
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, remove_caption: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None, api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        return self.copy_messages(String(chat_id), from_chat_id, message_ids, disable_notification, protect_content, message_thread_id, remove_caption, direct_messages_topic_id, api_kwargs)

    def copy_messages(
        mut self, chat_id: String, from_chat_id: Int, message_ids: List[Int],
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, remove_caption: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None, api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        return self.copy_messages(chat_id, String(from_chat_id), message_ids, disable_notification, protect_content, message_thread_id, remove_caption, direct_messages_topic_id, api_kwargs)

    def copy_messages(
        mut self, chat_id: Int, from_chat_id: Int, message_ids: List[Int],
        disable_notification: Optional[Bool] = None, protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None, remove_caption: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None, api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[MessageId]:
        return self.copy_messages(String(chat_id), String(from_chat_id), message_ids, disable_notification, protect_content, message_thread_id, remove_caption, direct_messages_topic_id, api_kwargs)

    def _forward_message(
        mut self,
        endpoint: String,
        chat_id: String,
        from_chat_id: String,
        message_id: Int,
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("from_chat_id", from_chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        var result = self._post_parameters(endpoint, parameters)
        return Message.de_json(result)

    def forward_message(
        mut self, chat_id: String, from_chat_id: String, message_id: Int
    ) raises -> Message:
        return self._forward_message("forward_message", chat_id, from_chat_id, message_id)

    def forward_message(
        mut self, chat_id: Int, from_chat_id: String, message_id: Int
    ) raises -> Message:
        return self.forward_message(String(chat_id), from_chat_id, message_id)

    def forward_message(
        mut self, chat_id: String, from_chat_id: Int, message_id: Int
    ) raises -> Message:
        return self.forward_message(chat_id, String(from_chat_id), message_id)

    def forward_message(
        mut self, chat_id: Int, from_chat_id: Int, message_id: Int
    ) raises -> Message:
        return self.forward_message(String(chat_id), String(from_chat_id), message_id)

    def copy_message(
        mut self,
        chat_id: String,
        from_chat_id: String,
        message_id: Int,
    ) raises -> MessageId:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("from_chat_id", from_chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        var result = self._post_parameters("copy_message", parameters)
        return MessageId.de_json(result)

    def copy_message(
        mut self, chat_id: Int, from_chat_id: String, message_id: Int
    ) raises -> MessageId:
        return self.copy_message(String(chat_id), from_chat_id, message_id)

    def copy_message(
        mut self, chat_id: String, from_chat_id: Int, message_id: Int
    ) raises -> MessageId:
        return self.copy_message(chat_id, String(from_chat_id), message_id)

    def copy_message(
        mut self, chat_id: Int, from_chat_id: Int, message_id: Int
    ) raises -> MessageId:
        return self.copy_message(String(chat_id), String(from_chat_id), message_id)

    def bot(mut self) raises -> User:
        if self.bot_user is None:
            raise Error("Bot is not initialized. Call initialize before accessing bot identity")
        return self.bot_user.value().copy()

    def id(mut self) raises -> Int:
        return self.bot().id

    def first_name(mut self) raises -> String:
        return self.bot().first_name.copy()

    def last_name(mut self) raises -> Optional[String]:
        return self.bot().last_name.copy()

    def username(mut self) raises -> Optional[String]:
        return self.bot().username.copy()

    def can_join_groups(mut self) raises -> Optional[Bool]:
        return self.bot().can_join_groups.copy()

    def can_read_all_group_messages(mut self) raises -> Optional[Bool]:
        return self.bot().can_read_all_group_messages.copy()

    def supports_inline_queries(mut self) raises -> Optional[Bool]:
        return self.bot().supports_inline_queries.copy()

    def link(mut self) raises -> String:
        var username = self.bot().username
        if username is None:
            raise TelegramError("Bot user has no username")
        return String("https://t.me/", username.value())

    def name(mut self) raises -> String:
        var username = self.bot().username
        if username is None:
            raise TelegramError("Bot user has no username")
        return String("@", username.value())

    def to_dict(mut self) raises -> JsonDocument:
        return self.bot().to_dict()

    def __repr__(self) -> String:
        return String("Bot[token=", self.token, "]")

    def set_user_emoji_status(
        mut self,
        user_id: Int,
        emoji_status_custom_emoji_id: Optional[String] = None,
        emoji_status_expiration_date: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if emoji_status_custom_emoji_id is not None:
            parameters.append(RequestParameter.from_input("emoji_status_custom_emoji_id", emoji_status_custom_emoji_id.value()))
        if emoji_status_expiration_date is not None:
            parameters.append(RequestParameter.from_input("emoji_status_expiration_date", emoji_status_expiration_date.value()))
        return self._post_bool_document(
            "set_user_emoji_status",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def get_forum_topic_icon_stickers(
        mut self, api_kwargs: Optional[JsonDocument] = None
    ) raises -> List[Sticker]:
        var result = self.do_api_request("get_forum_topic_icon_stickers", api_kwargs)
        return Sticker.de_list(result, result.root)

    def get_my_star_balance(
        mut self, api_kwargs: Optional[JsonDocument] = None
    ) raises -> StarAmount:
        var result = self.do_api_request("get_my_star_balance", api_kwargs)
        return StarAmount.de_json(result)

    def get_business_account_star_balance(
        mut self,
        business_connection_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> StarAmount:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        var result = self._post_parameters_with_api_kwargs(
            "get_business_account_star_balance", parameters^, api_kwargs
        )
        return StarAmount.de_json(result)

    def get_user_chat_boosts(
        mut self,
        chat_id: String,
        user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> UserChatBoosts:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        var result = self._post_parameters_with_api_kwargs(
            "get_user_chat_boosts", parameters^, api_kwargs
        )
        return UserChatBoosts.de_json(result)

    def get_user_chat_boosts(
        mut self,
        chat_id: Int,
        user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> UserChatBoosts:
        return self.get_user_chat_boosts(String(chat_id), user_id, api_kwargs)

    def gift_premium_subscription(
        mut self,
        user_id: Int,
        month_count: Int,
        star_count: Int,
        text: Optional[String] = None,
        text_parse_mode: Optional[String] = None,
        text_entities: Optional[JsonDocument] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("month_count", month_count))
        parameters.append(RequestParameter.from_input("star_count", star_count))
        if text is not None:
            parameters.append(RequestParameter.from_input("text", text.value()))
        if text_parse_mode is not None:
            parameters.append(RequestParameter.from_input("text_parse_mode", text_parse_mode.value()))
        if text_entities is not None:
            parameters.append(RequestParameter.from_input("text_entities", text_entities.value().copy()))
        return self._post_bool_document(
            "gift_premium_subscription",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def read_business_message(
        mut self,
        business_connection_id: String,
        chat_id: Int,
        message_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        return self._post_bool_document(
            "read_business_message",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def delete_business_messages(
        mut self,
        business_connection_id: String,
        message_ids: List[Int],
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var ids = JsonDocument()
        ids.root = ids.add_array()
        for message_id in message_ids:
            var child = ids.add_number(String(message_id))
            ids.append_child(ids.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("message_ids", ids))
        return self._post_bool_document(
            "delete_business_messages",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_chat_member_tag(
        mut self,
        chat_id: String,
        user_id: Int,
        tag: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if tag is not None:
            parameters.append(RequestParameter.from_input("tag", tag.value()))
        return self._post_bool_document(
            "set_chat_member_tag",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_chat_member_tag(
        mut self,
        chat_id: Int,
        user_id: Int,
        tag: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_chat_member_tag(String(chat_id), user_id, tag, api_kwargs)

    def unpin_all_forum_topic_messages(
        mut self,
        chat_id: String,
        message_thread_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id))
        return self._post_bool_document(
            "unpin_all_forum_topic_messages",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def unpin_all_forum_topic_messages(
        mut self, chat_id: Int, message_thread_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.unpin_all_forum_topic_messages(String(chat_id), message_thread_id, api_kwargs)

    def unpin_all_general_forum_topic_messages(
        mut self,
        chat_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        return self._post_bool_document(
            "unpin_all_general_forum_topic_messages",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def unpin_all_general_forum_topic_messages(
        mut self, chat_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.unpin_all_general_forum_topic_messages(String(chat_id), api_kwargs)

    def edit_general_forum_topic(
        mut self,
        chat_id: String,
        name: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("name", name))
        return self._post_bool_document(
            "edit_general_forum_topic",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def edit_general_forum_topic(
        mut self, chat_id: Int, name: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.edit_general_forum_topic(String(chat_id), name, api_kwargs)

    def close_general_forum_topic(
        mut self, chat_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self._forum_general_bool("close_general_forum_topic", chat_id, api_kwargs)

    def close_general_forum_topic(
        mut self, chat_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.close_general_forum_topic(String(chat_id), api_kwargs)

    def reopen_general_forum_topic(
        mut self, chat_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self._forum_general_bool("reopen_general_forum_topic", chat_id, api_kwargs)

    def reopen_general_forum_topic(
        mut self, chat_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.reopen_general_forum_topic(String(chat_id), api_kwargs)

    def hide_general_forum_topic(
        mut self, chat_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self._forum_general_bool("hide_general_forum_topic", chat_id, api_kwargs)

    def hide_general_forum_topic(
        mut self, chat_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.hide_general_forum_topic(String(chat_id), api_kwargs)

    def unhide_general_forum_topic(
        mut self, chat_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self._forum_general_bool("unhide_general_forum_topic", chat_id, api_kwargs)

    def unhide_general_forum_topic(
        mut self, chat_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.unhide_general_forum_topic(String(chat_id), api_kwargs)

    def answer_guest_query(
        mut self,
        guest_query_id: String,
        result_value: JsonDocument,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> SentGuestMessage:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("guest_query_id", guest_query_id))
        parameters.append(RequestParameter.from_input("result", result_value.copy()))
        var response = self._post_parameters_with_api_kwargs(
            "answer_guest_query", parameters^, api_kwargs
        )
        return SentGuestMessage.de_json(response)

    def get_sticker_set(
        mut self,
        name: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> StickerSet:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("name", name))
        var response = self._post_parameters_with_api_kwargs(
            "get_sticker_set", parameters^, api_kwargs
        )
        return StickerSet.de_json(response)

    def get_custom_emoji_stickers(
        mut self,
        custom_emoji_ids: List[String],
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[Sticker]:
        var values = JsonDocument()
        values.root = values.add_array()
        for custom_emoji_id in custom_emoji_ids:
            var child = values.add_string(custom_emoji_id)
            values.append_child(values.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("custom_emoji_ids", values))
        var response = self._post_parameters_with_api_kwargs(
            "get_custom_emoji_stickers", parameters^, api_kwargs
        )
        return Sticker.de_list(response, response.root)

    def get_available_gifts(
        mut self, api_kwargs: Optional[JsonDocument] = None
    ) raises -> Gifts:
        var response = self.do_api_request("get_available_gifts", api_kwargs)
        return Gifts.de_json(response)

    def send_gift(
        mut self,
        gift_id: String,
        text: Optional[String] = None,
        text_parse_mode: Optional[String] = None,
        text_entities: Optional[JsonDocument] = None,
        pay_for_upgrade: Optional[Bool] = None,
        chat_id: Optional[String] = None,
        user_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        if user_id is not None:
            parameters.append(RequestParameter.from_input("user_id", user_id.value()))
        parameters.append(RequestParameter.from_input("gift_id", gift_id))
        if text is not None:
            parameters.append(RequestParameter.from_input("text", text.value()))
        if text_parse_mode is not None:
            parameters.append(RequestParameter.from_input("text_parse_mode", text_parse_mode.value()))
        if text_entities is not None:
            parameters.append(RequestParameter.from_input("text_entities", text_entities.value().copy()))
        if pay_for_upgrade is not None:
            parameters.append(RequestParameter.from_input("pay_for_upgrade", pay_for_upgrade.value()))
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        return self._post_bool_document(
            "send_gift", _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        )

    def send_gift(
        mut self,
        gift: Gift,
        text: Optional[String] = None,
        text_parse_mode: Optional[String] = None,
        text_entities: Optional[JsonDocument] = None,
        pay_for_upgrade: Optional[Bool] = None,
        chat_id: Optional[String] = None,
        user_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.send_gift(
            gift.id, text, text_parse_mode, text_entities, pay_for_upgrade,
            chat_id, user_id, api_kwargs,
        )

    def set_business_account_name(
        mut self,
        business_connection_id: String,
        first_name: String,
        last_name: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("first_name", first_name))
        if last_name is not None:
            parameters.append(RequestParameter.from_input("last_name", last_name.value()))
        return self._post_bool_document(
            "set_business_account_name",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_business_account_username(
        mut self,
        business_connection_id: String,
        username: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        if username is not None:
            parameters.append(RequestParameter.from_input("username", username.value()))
        return self._post_bool_document(
            "set_business_account_username",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_business_account_bio(
        mut self,
        business_connection_id: String,
        bio: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        if bio is not None:
            parameters.append(RequestParameter.from_input("bio", bio.value()))
        return self._post_bool_document(
            "set_business_account_bio",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_business_account_gift_settings(
        mut self,
        business_connection_id: String,
        show_gift_button: Bool,
        accepted_gift_types: AcceptedGiftTypes,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("show_gift_button", show_gift_button))
        parameters.append(RequestParameter.from_input("accepted_gift_types", accepted_gift_types.to_dict()))
        return self._post_bool_document(
            "set_business_account_gift_settings",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_business_account_profile_photo(
        mut self,
        business_connection_id: String,
        photo: InputProfilePhoto,
        is_public: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("photo", photo.copy()))
        if is_public is not None:
            parameters.append(RequestParameter.from_input("is_public", is_public.value()))
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        return self._post_bool("set_business_account_profile_photo", merged^)

    def remove_business_account_profile_photo(
        mut self,
        business_connection_id: String,
        is_public: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        if is_public is not None:
            parameters.append(RequestParameter.from_input("is_public", is_public.value()))
        return self._post_bool_document(
            "remove_business_account_profile_photo",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def delete_sticker_from_set(
        mut self,
        sticker: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("sticker", sticker))
        return self._post_bool_document(
            "delete_sticker_from_set",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def delete_sticker_from_set(
        mut self, sticker: Sticker,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.delete_sticker_from_set(sticker.file_id, api_kwargs)

    def delete_sticker_set(
        mut self,
        name: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("name", name))
        return self._post_bool_document(
            "delete_sticker_set",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_sticker_set_title(
        mut self,
        name: String,
        title: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("name", name))
        parameters.append(RequestParameter.from_input("title", title))
        return self._post_bool_document(
            "set_sticker_set_title",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_sticker_position_in_set(
        mut self,
        sticker: String,
        position: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("sticker", sticker))
        parameters.append(RequestParameter.from_input("position", position))
        return self._post_bool_document(
            "set_sticker_position_in_set",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_sticker_position_in_set(
        mut self, sticker: Sticker, position: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_sticker_position_in_set(sticker.file_id, position, api_kwargs)

    def set_sticker_emoji_list(
        mut self,
        sticker: String,
        emoji_list: List[String],
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var values = JsonDocument()
        values.root = values.add_array()
        for emoji in emoji_list:
            var child = values.add_string(emoji)
            values.append_child(values.root, child)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("sticker", sticker))
        parameters.append(RequestParameter.from_input("emoji_list", values))
        return self._post_bool_document(
            "set_sticker_emoji_list",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_sticker_emoji_list(
        mut self, sticker: Sticker, emoji_list: List[String],
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_sticker_emoji_list(sticker.file_id, emoji_list, api_kwargs)

    def set_sticker_keywords(
        mut self,
        sticker: String,
        keywords: Optional[List[String]] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("sticker", sticker))
        if keywords is not None:
            var values = JsonDocument()
            values.root = values.add_array()
            for keyword in keywords.value():
                var child = values.add_string(keyword)
                values.append_child(values.root, child)
            parameters.append(RequestParameter.from_input("keywords", values))
        return self._post_bool_document(
            "set_sticker_keywords",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_sticker_keywords(
        mut self, sticker: Sticker, keywords: Optional[List[String]] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_sticker_keywords(sticker.file_id, keywords, api_kwargs)

    def set_sticker_mask_position(
        mut self,
        sticker: String,
        mask_position: Optional[MaskPosition] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("sticker", sticker))
        if mask_position is not None:
            parameters.append(RequestParameter.from_input("mask_position", mask_position.value().to_dict()))
        return self._post_bool_document(
            "set_sticker_mask_position",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_sticker_mask_position(
        mut self, sticker: Sticker, mask_position: Optional[MaskPosition] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.set_sticker_mask_position(sticker.file_id, mask_position, api_kwargs)

    def set_custom_emoji_sticker_set_thumbnail(
        mut self,
        name: String,
        custom_emoji_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("name", name))
        if custom_emoji_id is not None:
            parameters.append(RequestParameter.from_input("custom_emoji_id", custom_emoji_id.value()))
        return self._post_bool_document(
            "set_custom_emoji_sticker_set_thumbnail",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def upload_sticker_file(
        mut self,
        user_id: Int,
        sticker: InputFile,
        sticker_format: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> File:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("sticker", sticker.copy()))
        parameters.append(RequestParameter.from_input("sticker_format", sticker_format))
        var response = self._post_parameters_with_api_kwargs(
            "upload_sticker_file", parameters^, api_kwargs
        )
        return File.de_json(response)

    def upload_sticker_file(
        mut self,
        user_id: Int,
        sticker: String,
        sticker_format: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> File:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("sticker", sticker))
        parameters.append(RequestParameter.from_input("sticker_format", sticker_format))
        var response = self._post_parameters_with_api_kwargs(
            "upload_sticker_file", parameters^, api_kwargs
        )
        return File.de_json(response)

    def add_sticker_to_set(
        mut self,
        user_id: Int,
        name: String,
        sticker: InputSticker,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("name", name))
        parameters.append(RequestParameter.from_input("sticker", sticker.copy()))
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        return self._post_bool("add_sticker_to_set", merged^)

    def replace_sticker_in_set(
        mut self,
        user_id: Int,
        name: String,
        old_sticker: String,
        sticker: InputSticker,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("name", name))
        parameters.append(RequestParameter.from_input("old_sticker", old_sticker))
        parameters.append(RequestParameter.from_input("sticker", sticker.copy()))
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        return self._post_bool("replace_sticker_in_set", merged^)

    def replace_sticker_in_set(
        mut self,
        user_id: Int,
        name: String,
        old_sticker: Sticker,
        sticker: InputSticker,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.replace_sticker_in_set(
            user_id, name, old_sticker.file_id, sticker, api_kwargs
        )

    def create_new_sticker_set(
        mut self,
        user_id: Int,
        name: String,
        title: String,
        stickers: List[InputSticker],
        sticker_type: Optional[String] = None,
        needs_repainting: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var sticker_array = JsonDocument()
        sticker_array.root = sticker_array.add_array()
        var uploads = List[InputFile]()
        for sticker in stickers:
            var item = sticker.to_dict()
            var child = sticker_array.copy_subtree_from(item, item.root)
            sticker_array.append_child(sticker_array.root, child)
            if sticker.sticker.kind == ParsedFileInput.UPLOAD:
                uploads.append(sticker.sticker.input_file.value().copy())
            elif sticker.sticker.kind == ParsedFileInput.PATH:
                raise Error("A non-local sticker Path cannot be serialized")
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("name", name))
        parameters.append(RequestParameter.from_input("title", title))
        parameters.append(RequestParameter("stickers", Optional[JsonDocument](sticker_array.copy()), uploads^))
        if sticker_type is not None:
            parameters.append(RequestParameter.from_input("sticker_type", sticker_type.value()))
        if needs_repainting is not None:
            parameters.append(RequestParameter.from_input("needs_repainting", needs_repainting.value()))
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        return self._post_bool("create_new_sticker_set", merged^)

    def set_sticker_set_thumbnail(
        mut self,
        name: String,
        user_id: Int,
        sticker_format: String,
        thumbnail: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("name", name))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("format", sticker_format))
        if thumbnail is not None:
            parameters.append(RequestParameter.from_input("thumbnail", thumbnail.value()))
        return self._post_bool_document(
            "set_sticker_set_thumbnail",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_sticker_set_thumbnail(
        mut self,
        name: String,
        user_id: Int,
        sticker_format: String,
        thumbnail: InputFile,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("name", name))
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("format", sticker_format))
        parameters.append(RequestParameter.from_input("thumbnail", thumbnail.copy()))
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        return self._post_bool("set_sticker_set_thumbnail", merged^)

    def set_game_score(
        mut self,
        user_id: Int,
        score: Int,
        chat_id: Optional[Int] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        force: Optional[Bool] = None,
        disable_edit_message: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("score", score))
        if force is not None:
            parameters.append(RequestParameter.from_input("force", force.value()))
        if disable_edit_message is not None:
            parameters.append(RequestParameter.from_input("disable_edit_message", disable_edit_message.value()))
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        return self._post_edit_result("set_game_score", parameters^, api_kwargs)

    def get_game_high_scores(
        mut self,
        user_id: Int,
        chat_id: Optional[Int] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[GameHighScore]:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        var response = self._post_parameters_with_api_kwargs(
            "get_game_high_scores", parameters^, api_kwargs
        )
        return GameHighScore.de_list(response, response.root)

    def create_chat_subscription_invite_link(
        mut self,
        chat_id: String,
        subscription_period: Int,
        subscription_price: Int,
        name: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("subscription_period", subscription_period))
        parameters.append(RequestParameter.from_input("subscription_price", subscription_price))
        if name is not None:
            parameters.append(RequestParameter.from_input("name", name.value()))
        var response = self._post_parameters_with_api_kwargs(
            "create_chat_subscription_invite_link", parameters^, api_kwargs
        )
        return ChatInviteLink.de_json(response)

    def create_chat_subscription_invite_link(
        mut self,
        chat_id: Int,
        subscription_period: Int,
        subscription_price: Int,
        name: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.create_chat_subscription_invite_link(
            String(chat_id), subscription_period, subscription_price, name, api_kwargs
        )

    def edit_chat_subscription_invite_link(
        mut self,
        chat_id: String,
        invite_link: String,
        name: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("invite_link", invite_link))
        if name is not None:
            parameters.append(RequestParameter.from_input("name", name.value()))
        var response = self._post_parameters_with_api_kwargs(
            "edit_chat_subscription_invite_link", parameters^, api_kwargs
        )
        return ChatInviteLink.de_json(response)

    def edit_chat_subscription_invite_link(
        mut self,
        chat_id: Int,
        invite_link: String,
        name: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.edit_chat_subscription_invite_link(
            String(chat_id), invite_link, name, api_kwargs
        )

    def edit_chat_subscription_invite_link(
        mut self,
        chat_id: Int,
        invite_link: ChatInviteLink,
        name: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.edit_chat_subscription_invite_link(
            chat_id, invite_link.invite_link, name, api_kwargs
        )

    def edit_chat_subscription_invite_link(
        mut self,
        chat_id: String,
        invite_link: ChatInviteLink,
        name: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> ChatInviteLink:
        return self.edit_chat_subscription_invite_link(
            chat_id, invite_link.invite_link, name, api_kwargs
        )

    def convert_gift_to_stars(
        mut self,
        business_connection_id: String,
        owned_gift_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("owned_gift_id", owned_gift_id))
        return self._post_bool_document(
            "convert_gift_to_stars",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def upgrade_gift(
        mut self,
        business_connection_id: String,
        owned_gift_id: String,
        keep_original_details: Optional[Bool] = None,
        star_count: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("owned_gift_id", owned_gift_id))
        if keep_original_details is not None:
            parameters.append(RequestParameter.from_input("keep_original_details", keep_original_details.value()))
        if star_count is not None:
            parameters.append(RequestParameter.from_input("star_count", star_count.value()))
        return self._post_bool_document(
            "upgrade_gift",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def transfer_gift(
        mut self,
        business_connection_id: String,
        owned_gift_id: String,
        new_owner_chat_id: Int,
        star_count: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("owned_gift_id", owned_gift_id))
        parameters.append(RequestParameter.from_input("new_owner_chat_id", new_owner_chat_id))
        if star_count is not None:
            parameters.append(RequestParameter.from_input("star_count", star_count.value()))
        return self._post_bool_document(
            "transfer_gift",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def verify_chat(
        mut self,
        chat_id: String,
        custom_description: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if custom_description is not None:
            parameters.append(RequestParameter.from_input("custom_description", custom_description.value()))
        return self._post_bool_document(
            "verify_chat", _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        )

    def verify_chat(
        mut self, chat_id: Int,
        custom_description: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.verify_chat(String(chat_id), custom_description, api_kwargs)

    def verify_user(
        mut self,
        user_id: Int,
        custom_description: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if custom_description is not None:
            parameters.append(RequestParameter.from_input("custom_description", custom_description.value()))
        return self._post_bool_document(
            "verify_user", _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        )

    def remove_chat_verification(
        mut self,
        chat_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        return self._post_bool_document(
            "remove_chat_verification",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def remove_chat_verification(
        mut self, chat_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        return self.remove_chat_verification(String(chat_id), api_kwargs)

    def remove_user_verification(
        mut self,
        user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        return self._post_bool_document(
            "remove_user_verification",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def get_managed_bot_token(
        mut self, user_id: Int, api_kwargs: Optional[JsonDocument] = None
    ) raises -> String:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        var response = self._post_parameters_with_api_kwargs(
            "get_managed_bot_token", parameters^, api_kwargs
        )
        return response.string_value(response.root)

    def replace_managed_bot_token(
        mut self, user_id: Int, api_kwargs: Optional[JsonDocument] = None
    ) raises -> String:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        var response = self._post_parameters_with_api_kwargs(
            "replace_managed_bot_token", parameters^, api_kwargs
        )
        return response.string_value(response.root)

    def get_user_gifts(
        mut self,
        user_id: Int,
        exclude_unlimited: Optional[Bool] = None,
        exclude_limited_upgradable: Optional[Bool] = None,
        exclude_limited_non_upgradable: Optional[Bool] = None,
        exclude_from_blockchain: Optional[Bool] = None,
        exclude_unique: Optional[Bool] = None,
        sort_by_price: Optional[Bool] = None,
        offset: Optional[String] = None,
        limit: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> OwnedGifts:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if exclude_unlimited is not None:
            parameters.append(RequestParameter.from_input("exclude_unlimited", exclude_unlimited.value()))
        if exclude_limited_upgradable is not None:
            parameters.append(RequestParameter.from_input("exclude_limited_upgradable", exclude_limited_upgradable.value()))
        if exclude_limited_non_upgradable is not None:
            parameters.append(RequestParameter.from_input("exclude_limited_non_upgradable", exclude_limited_non_upgradable.value()))
        if exclude_from_blockchain is not None:
            parameters.append(RequestParameter.from_input("exclude_from_blockchain", exclude_from_blockchain.value()))
        if exclude_unique is not None:
            parameters.append(RequestParameter.from_input("exclude_unique", exclude_unique.value()))
        if sort_by_price is not None:
            parameters.append(RequestParameter.from_input("sort_by_price", sort_by_price.value()))
        if offset is not None:
            parameters.append(RequestParameter.from_input("offset", offset.value()))
        if limit is not None:
            parameters.append(RequestParameter.from_input("limit", limit.value()))
        var response = self._post_parameters_with_api_kwargs("get_user_gifts", parameters^, api_kwargs)
        return OwnedGifts.de_json(response)

    def get_chat_gifts(
        mut self,
        chat_id: String,
        exclude_unsaved: Optional[Bool] = None,
        exclude_saved: Optional[Bool] = None,
        exclude_unlimited: Optional[Bool] = None,
        exclude_limited_upgradable: Optional[Bool] = None,
        exclude_limited_non_upgradable: Optional[Bool] = None,
        exclude_from_blockchain: Optional[Bool] = None,
        exclude_unique: Optional[Bool] = None,
        sort_by_price: Optional[Bool] = None,
        offset: Optional[String] = None,
        limit: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> OwnedGifts:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        if exclude_unsaved is not None:
            parameters.append(RequestParameter.from_input("exclude_unsaved", exclude_unsaved.value()))
        if exclude_saved is not None:
            parameters.append(RequestParameter.from_input("exclude_saved", exclude_saved.value()))
        if exclude_unlimited is not None:
            parameters.append(RequestParameter.from_input("exclude_unlimited", exclude_unlimited.value()))
        if exclude_limited_upgradable is not None:
            parameters.append(RequestParameter.from_input("exclude_limited_upgradable", exclude_limited_upgradable.value()))
        if exclude_limited_non_upgradable is not None:
            parameters.append(RequestParameter.from_input("exclude_limited_non_upgradable", exclude_limited_non_upgradable.value()))
        if exclude_from_blockchain is not None:
            parameters.append(RequestParameter.from_input("exclude_from_blockchain", exclude_from_blockchain.value()))
        if exclude_unique is not None:
            parameters.append(RequestParameter.from_input("exclude_unique", exclude_unique.value()))
        if sort_by_price is not None:
            parameters.append(RequestParameter.from_input("sort_by_price", sort_by_price.value()))
        if offset is not None:
            parameters.append(RequestParameter.from_input("offset", offset.value()))
        if limit is not None:
            parameters.append(RequestParameter.from_input("limit", limit.value()))
        var response = self._post_parameters_with_api_kwargs("get_chat_gifts", parameters^, api_kwargs)
        return OwnedGifts.de_json(response)

    def get_chat_gifts(
        mut self,
        chat_id: Int,
        exclude_unsaved: Optional[Bool] = None,
        exclude_saved: Optional[Bool] = None,
        exclude_unlimited: Optional[Bool] = None,
        exclude_limited_upgradable: Optional[Bool] = None,
        exclude_limited_non_upgradable: Optional[Bool] = None,
        exclude_from_blockchain: Optional[Bool] = None,
        exclude_unique: Optional[Bool] = None,
        sort_by_price: Optional[Bool] = None,
        offset: Optional[String] = None,
        limit: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> OwnedGifts:
        return self.get_chat_gifts(
            String(chat_id), exclude_unsaved, exclude_saved, exclude_unlimited,
            exclude_limited_upgradable, exclude_limited_non_upgradable,
            exclude_from_blockchain, exclude_unique, sort_by_price, offset, limit, api_kwargs,
        )

    def get_business_account_gifts(
        mut self,
        business_connection_id: String,
        exclude_unsaved: Optional[Bool] = None,
        exclude_saved: Optional[Bool] = None,
        exclude_unlimited: Optional[Bool] = None,
        exclude_limited_upgradable: Optional[Bool] = None,
        exclude_limited_non_upgradable: Optional[Bool] = None,
        exclude_unique: Optional[Bool] = None,
        exclude_from_blockchain: Optional[Bool] = None,
        sort_by_price: Optional[Bool] = None,
        offset: Optional[String] = None,
        limit: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> OwnedGifts:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        if exclude_unsaved is not None:
            parameters.append(RequestParameter.from_input("exclude_unsaved", exclude_unsaved.value()))
        if exclude_saved is not None:
            parameters.append(RequestParameter.from_input("exclude_saved", exclude_saved.value()))
        if exclude_unlimited is not None:
            parameters.append(RequestParameter.from_input("exclude_unlimited", exclude_unlimited.value()))
        if exclude_limited_upgradable is not None:
            parameters.append(RequestParameter.from_input("exclude_limited_upgradable", exclude_limited_upgradable.value()))
        if exclude_limited_non_upgradable is not None:
            parameters.append(RequestParameter.from_input("exclude_limited_non_upgradable", exclude_limited_non_upgradable.value()))
        if exclude_unique is not None:
            parameters.append(RequestParameter.from_input("exclude_unique", exclude_unique.value()))
        if exclude_from_blockchain is not None:
            parameters.append(RequestParameter.from_input("exclude_from_blockchain", exclude_from_blockchain.value()))
        if sort_by_price is not None:
            parameters.append(RequestParameter.from_input("sort_by_price", sort_by_price.value()))
        if offset is not None:
            parameters.append(RequestParameter.from_input("offset", offset.value()))
        if limit is not None:
            parameters.append(RequestParameter.from_input("limit", limit.value()))
        var response = self._post_parameters_with_api_kwargs(
            "get_business_account_gifts", parameters^, api_kwargs
        )
        return OwnedGifts.de_json(response)

    def transfer_business_account_stars(
        mut self,
        business_connection_id: String,
        star_count: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("star_count", star_count))
        return self._post_bool_document(
            "transfer_business_account_stars",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def refund_star_payment(
        mut self,
        user_id: Int,
        telegram_payment_charge_id: String,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("telegram_payment_charge_id", telegram_payment_charge_id))
        return self._post_bool_document(
            "refund_star_payment",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def edit_user_star_subscription(
        mut self,
        user_id: Int,
        telegram_payment_charge_id: String,
        is_canceled: Bool,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("telegram_payment_charge_id", telegram_payment_charge_id))
        parameters.append(RequestParameter.from_input("is_canceled", is_canceled))
        return self._post_bool_document(
            "edit_user_star_subscription",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def get_star_transactions(
        mut self,
        offset: Optional[Int] = None,
        limit: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> StarTransactions:
        var parameters = List[RequestParameter]()
        if offset is not None:
            parameters.append(RequestParameter.from_input("offset", offset.value()))
        if limit is not None:
            parameters.append(RequestParameter.from_input("limit", limit.value()))
        var response = self._post_parameters_with_api_kwargs(
            "get_star_transactions", parameters^, api_kwargs
        )
        return StarTransactions.de_json(response)

    def get_user_profile_audios(
        mut self,
        user_id: Int,
        offset: Optional[Int] = None,
        limit: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> UserProfileAudios:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        if offset is not None:
            parameters.append(RequestParameter.from_input("offset", offset.value()))
        if limit is not None:
            parameters.append(RequestParameter.from_input("limit", limit.value()))
        var response = self._post_parameters_with_api_kwargs(
            "get_user_profile_audios", parameters^, api_kwargs
        )
        return UserProfileAudios.de_json(response)

    def get_managed_bot_access_settings(
        mut self,
        user_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> BotAccessSettings:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        var response = self._post_parameters_with_api_kwargs(
            "get_managed_bot_access_settings", parameters^, api_kwargs
        )
        return BotAccessSettings.de_json(response)

    def set_managed_bot_access_settings(
        mut self,
        user_id: Int,
        is_access_restricted: Bool,
        added_user_ids: Optional[List[Int]] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("is_access_restricted", is_access_restricted))
        if added_user_ids is not None:
            var values = JsonDocument()
            values.root = values.add_array()
            for user_id_value in added_user_ids.value():
                var child = values.add_number(String(user_id_value))
                values.append_child(values.root, child)
            parameters.append(RequestParameter.from_input("added_user_ids", values))
        return self._post_bool_document(
            "set_managed_bot_access_settings",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def get_user_personal_chat_messages(
        mut self,
        user_id: Int,
        limit: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> List[Message]:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("limit", limit))
        var response = self._post_parameters_with_api_kwargs(
            "get_user_personal_chat_messages", parameters^, api_kwargs
        )
        return Message.de_list(response, response.root)

    def approve_suggested_post(
        mut self,
        chat_id: Int,
        message_id: Int,
        send_date: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        if send_date is not None:
            parameters.append(RequestParameter.from_input("send_date", send_date.value()))
        return self._post_bool_document(
            "approve_suggested_post",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def decline_suggested_post(
        mut self,
        chat_id: Int,
        message_id: Int,
        comment: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        if comment is not None:
            parameters.append(RequestParameter.from_input("comment", comment.value()))
        return self._post_bool_document(
            "decline_suggested_post",
            _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs),
        )

    def set_my_profile_photo(
        mut self,
        photo: InputProfilePhoto,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("photo", photo.copy()))
        var merged = _bot_merge_request_parameters(parameters^, api_kwargs)
        return self._post_bool("set_my_profile_photo", merged^)

    def remove_my_profile_photo(
        mut self, api_kwargs: Optional[JsonDocument] = None
    ) raises -> Bool:
        var parameters = _bot_request_parameters(api_kwargs)
        return self._post_bool("remove_my_profile_photo", parameters^)

    def send_checklist(
        mut self,
        business_connection_id: String,
        chat_id: String,
        checklist: InputChecklist,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_effect_id: Optional[String] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        reply_markup: Optional[JsonDocument] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        if reply_parameters is not None and (
            allow_sending_without_reply is not None or reply_to_message_id is not None
        ):
            raise Error("reply_parameters cannot be combined with reply convenience parameters")
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("checklist", checklist.to_dict()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_effect_id is not None:
            parameters.append(RequestParameter.from_input("message_effect_id", message_effect_id.value()))
        if reply_parameters is not None:
            parameters.append(RequestParameter.from_input("reply_parameters", reply_parameters.value().to_dict()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if allow_sending_without_reply is not None:
            parameters.append(RequestParameter.from_input("allow_sending_without_reply", allow_sending_without_reply.value()))
        if reply_to_message_id is not None:
            parameters.append(RequestParameter.from_input("reply_to_message_id", reply_to_message_id.value()))
        var response = self._post_parameters_with_api_kwargs("send_checklist", parameters^, api_kwargs)
        return Message.de_json(response)

    def send_checklist(
        mut self,
        business_connection_id: String,
        chat_id: Int,
        checklist: InputChecklist,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_effect_id: Optional[String] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        reply_markup: Optional[JsonDocument] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_checklist(
            business_connection_id, String(chat_id), checklist, disable_notification,
            protect_content, message_effect_id, reply_parameters, reply_markup,
            allow_sending_without_reply, reply_to_message_id, api_kwargs,
        )

    def edit_message_checklist(
        mut self,
        business_connection_id: String,
        chat_id: String,
        message_id: Int,
        checklist: InputChecklist,
        reply_markup: Optional[JsonDocument] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("message_id", message_id))
        parameters.append(RequestParameter.from_input("checklist", checklist.to_dict()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        var response = self._post_parameters_with_api_kwargs("edit_message_checklist", parameters^, api_kwargs)
        return Message.de_json(response)

    def edit_message_checklist(
        mut self,
        business_connection_id: String,
        chat_id: Int,
        message_id: Int,
        checklist: InputChecklist,
        reply_markup: Optional[JsonDocument] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.edit_message_checklist(
            business_connection_id, String(chat_id), message_id, checklist,
            reply_markup, api_kwargs,
        )

    def _forum_general_bool(
        mut self,
        endpoint: String,
        chat_id: String,
        api_kwargs: Optional[JsonDocument],
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        return self._post_bool_document(
            endpoint, _bot_merge_api_kwargs(_bot_parameter_document(parameters), api_kwargs)
        )

    def post_story(
        mut self,
        business_connection_id: String,
        content: InputStoryContent,
        active_period: Int,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        areas: Optional[List[StoryArea]] = None,
        post_to_chat_page: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Story:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("content", content))
        parameters.append(RequestParameter.from_input("active_period", active_period))
        if caption is not None:
            parameters.append(RequestParameter.from_input("caption", caption.value()))
        if parse_mode is not None:
            parameters.append(RequestParameter.from_input("parse_mode", parse_mode.value()))
        if caption_entities is not None:
            parameters.append(RequestParameter.from_input("caption_entities", _bot_message_entity_array(caption_entities.value())))
        if areas is not None:
            parameters.append(RequestParameter.from_input("areas", _bot_story_area_array(areas.value())))
        if post_to_chat_page is not None:
            parameters.append(RequestParameter.from_input("post_to_chat_page", post_to_chat_page.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        var result = self._post_parameters_with_api_kwargs("post_story", parameters^, api_kwargs)
        return Story.de_json(result)

    def post_story(
        mut self,
        business_connection_id: String,
        content: InputStoryContent,
        active_period: TimeDelta,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        areas: Optional[List[StoryArea]] = None,
        post_to_chat_page: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Story:
        return self.post_story(
            business_connection_id, content, Int(active_period.total_seconds()), caption,
            parse_mode, caption_entities, areas, post_to_chat_page, protect_content, api_kwargs,
        )

    def edit_story(
        mut self,
        business_connection_id: String,
        story_id: Int,
        content: InputStoryContent,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        areas: Optional[List[StoryArea]] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Story:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("story_id", story_id))
        parameters.append(RequestParameter.from_input("content", content))
        if caption is not None:
            parameters.append(RequestParameter.from_input("caption", caption.value()))
        if parse_mode is not None:
            parameters.append(RequestParameter.from_input("parse_mode", parse_mode.value()))
        if caption_entities is not None:
            parameters.append(RequestParameter.from_input("caption_entities", _bot_message_entity_array(caption_entities.value())))
        if areas is not None:
            parameters.append(RequestParameter.from_input("areas", _bot_story_area_array(areas.value())))
        var result = self._post_parameters_with_api_kwargs("edit_story", parameters^, api_kwargs)
        return Story.de_json(result)

    def delete_story(
        mut self,
        business_connection_id: String,
        story_id: Int,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("story_id", story_id))
        var result = self._post_parameters_with_api_kwargs("delete_story", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def repost_story(
        mut self,
        business_connection_id: String,
        from_chat_id: Int,
        from_story_id: Int,
        active_period: Int,
        post_to_chat_page: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Story:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id))
        parameters.append(RequestParameter.from_input("from_chat_id", from_chat_id))
        parameters.append(RequestParameter.from_input("from_story_id", from_story_id))
        parameters.append(RequestParameter.from_input("active_period", active_period))
        if post_to_chat_page is not None:
            parameters.append(RequestParameter.from_input("post_to_chat_page", post_to_chat_page.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        var result = self._post_parameters_with_api_kwargs("repost_story", parameters^, api_kwargs)
        return Story.de_json(result)

    def save_prepared_keyboard_button(
        mut self,
        user_id: Int,
        button: KeyboardButton,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> PreparedKeyboardButton:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("button", button.to_dict()))
        var result = self._post_parameters_with_api_kwargs("save_prepared_keyboard_button", parameters^, api_kwargs)
        return PreparedKeyboardButton.de_json(result)

    def set_passport_data_errors(
        mut self,
        user_id: Int,
        errors: JsonDocument,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Bool:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("user_id", user_id))
        parameters.append(RequestParameter.from_input("errors", errors.copy()))
        var result = self._post_parameters_with_api_kwargs("set_passport_data_errors", parameters^, api_kwargs)
        return result.boolean_value(result.root)

    def _send_live_photo(
        mut self,
        chat_id: String,
        live_photo: ParsedFileInput,
        photo: ParsedFileInput,
        business_connection_id: Optional[String],
        message_thread_id: Optional[Int],
        direct_messages_topic_id: Optional[Int],
        caption: Optional[String],
        parse_mode: Optional[String],
        caption_entities: Optional[List[MessageEntity]],
        show_caption_above_media: Optional[Bool],
        has_spoiler: Optional[Bool],
        disable_notification: Optional[Bool],
        protect_content: Optional[Bool],
        allow_paid_broadcast: Optional[Bool],
        message_effect_id: Optional[String],
        reply_parameters: Optional[ReplyParameters],
        reply_markup: Optional[JsonDocument],
        allow_sending_without_reply: Optional[Bool],
        reply_to_message_id: Optional[Int],
        api_kwargs: Optional[JsonDocument],
    ) raises -> Message:
        if reply_parameters is not None and (
            allow_sending_without_reply is not None or reply_to_message_id is not None
        ):
            raise Error("reply_parameters cannot be combined with reply convenience parameters")
        var resolved_reply_parameters = reply_parameters.copy()
        if reply_to_message_id is not None:
            var generated_reply = ReplyParameters(reply_to_message_id.value())
            if allow_sending_without_reply is not None:
                generated_reply.allow_sending_without_reply = allow_sending_without_reply
            resolved_reply_parameters = Optional[ReplyParameters](generated_reply^)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("live_photo", live_photo))
        parameters.append(RequestParameter.from_input("photo", photo))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        if caption is not None:
            parameters.append(RequestParameter.from_input("caption", caption.value()))
        if parse_mode is not None:
            parameters.append(RequestParameter.from_input("parse_mode", parse_mode.value()))
        if caption_entities is not None:
            parameters.append(RequestParameter.from_input("caption_entities", _bot_message_entity_array(caption_entities.value())))
        if show_caption_above_media is not None:
            parameters.append(RequestParameter.from_input("show_caption_above_media", show_caption_above_media.value()))
        if has_spoiler is not None:
            parameters.append(RequestParameter.from_input("has_spoiler", has_spoiler.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if allow_paid_broadcast is not None:
            parameters.append(RequestParameter.from_input("allow_paid_broadcast", allow_paid_broadcast.value()))
        if message_effect_id is not None:
            parameters.append(RequestParameter.from_input("message_effect_id", message_effect_id.value()))
        if resolved_reply_parameters is not None:
            parameters.append(RequestParameter.from_input("reply_parameters", resolved_reply_parameters.value().to_dict()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        var result = self._post_parameters_with_api_kwargs("send_live_photo", parameters^, api_kwargs)
        return Message.de_json(result)

    def send_live_photo(
        mut self,
        chat_id: String,
        live_photo: String,
        photo: String,
        business_connection_id: Optional[String] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        show_caption_above_media: Optional[Bool] = None,
        has_spoiler: Optional[Bool] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        message_effect_id: Optional[String] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        reply_markup: Optional[JsonDocument] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self._send_live_photo(
            chat_id, parse_file_input(live_photo, attach=True, local_mode=True),
            parse_file_input(photo, attach=True, local_mode=True), business_connection_id,
            message_thread_id, direct_messages_topic_id, caption, parse_mode, caption_entities,
            show_caption_above_media, has_spoiler, disable_notification, protect_content,
            allow_paid_broadcast, message_effect_id, reply_parameters, reply_markup,
            allow_sending_without_reply, reply_to_message_id, api_kwargs,
        )

    def send_live_photo(
        mut self,
        chat_id: Int,
        live_photo: String,
        photo: String,
        business_connection_id: Optional[String] = None,
        message_thread_id: Optional[Int] = None,
        direct_messages_topic_id: Optional[Int] = None,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        show_caption_above_media: Optional[Bool] = None,
        has_spoiler: Optional[Bool] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        message_effect_id: Optional[String] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        reply_markup: Optional[JsonDocument] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_live_photo(
            String(chat_id), live_photo, photo, business_connection_id, message_thread_id,
            direct_messages_topic_id, caption, parse_mode, caption_entities,
            show_caption_above_media, has_spoiler, disable_notification, protect_content,
            allow_paid_broadcast, message_effect_id, reply_parameters, reply_markup,
            allow_sending_without_reply, reply_to_message_id, api_kwargs,
        )

    def send_invoice(
        mut self,
        chat_id: String,
        title: String,
        description: String,
        payload: String,
        currency: String,
        prices: List[LabeledPrice],
        provider_token: Optional[String] = None,
        start_parameter: Optional[String] = None,
        photo_url: Optional[String] = None,
        photo_size: Optional[Int] = None,
        photo_width: Optional[Int] = None,
        photo_height: Optional[Int] = None,
        need_name: Optional[Bool] = None,
        need_phone_number: Optional[Bool] = None,
        need_email: Optional[Bool] = None,
        need_shipping_address: Optional[Bool] = None,
        is_flexible: Optional[Bool] = None,
        disable_notification: Optional[Bool] = None,
        reply_markup: Optional[JsonDocument] = None,
        provider_data: Optional[JsonDocument] = None,
        send_phone_number_to_provider: Optional[Bool] = None,
        send_email_to_provider: Optional[Bool] = None,
        max_tip_amount: Optional[Int] = None,
        suggested_tip_amounts: Optional[List[Int]] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        message_effect_id: Optional[String] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None,
        suggested_post_parameters: Optional[JsonDocument] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        if reply_parameters is not None and (
            allow_sending_without_reply is not None or reply_to_message_id is not None
        ):
            raise Error("reply_parameters cannot be combined with reply convenience parameters")
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("title", title))
        parameters.append(RequestParameter.from_input("description", description))
        parameters.append(RequestParameter.from_input("payload", payload))
        parameters.append(RequestParameter.from_input("currency", currency))
        parameters.append(RequestParameter.from_input("prices", _bot_labeled_price_array(prices)))
        if provider_token is not None:
            parameters.append(RequestParameter.from_input("provider_token", provider_token.value()))
        if start_parameter is not None:
            parameters.append(RequestParameter.from_input("start_parameter", start_parameter.value()))
        if photo_url is not None:
            parameters.append(RequestParameter.from_input("photo_url", photo_url.value()))
        if photo_size is not None:
            parameters.append(RequestParameter.from_input("photo_size", photo_size.value()))
        if photo_width is not None:
            parameters.append(RequestParameter.from_input("photo_width", photo_width.value()))
        if photo_height is not None:
            parameters.append(RequestParameter.from_input("photo_height", photo_height.value()))
        if need_name is not None:
            parameters.append(RequestParameter.from_input("need_name", need_name.value()))
        if need_phone_number is not None:
            parameters.append(RequestParameter.from_input("need_phone_number", need_phone_number.value()))
        if need_email is not None:
            parameters.append(RequestParameter.from_input("need_email", need_email.value()))
        if need_shipping_address is not None:
            parameters.append(RequestParameter.from_input("need_shipping_address", need_shipping_address.value()))
        if is_flexible is not None:
            parameters.append(RequestParameter.from_input("is_flexible", is_flexible.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if provider_data is not None:
            var provider = provider_data.value().copy()
            if provider.nodes[provider.root].kind == JSON_STRING:
                parameters.append(RequestParameter.from_input("provider_data", provider.string_value(provider.root)))
            else:
                parameters.append(RequestParameter.from_input("provider_data", dumps_json(provider)))
        if send_phone_number_to_provider is not None:
            parameters.append(RequestParameter.from_input("send_phone_number_to_provider", send_phone_number_to_provider.value()))
        if send_email_to_provider is not None:
            parameters.append(RequestParameter.from_input("send_email_to_provider", send_email_to_provider.value()))
        if max_tip_amount is not None:
            parameters.append(RequestParameter.from_input("max_tip_amount", max_tip_amount.value()))
        if suggested_tip_amounts is not None:
            parameters.append(RequestParameter.from_input("suggested_tip_amounts", _bot_integer_array(suggested_tip_amounts.value())))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if reply_parameters is not None:
            parameters.append(RequestParameter.from_input("reply_parameters", reply_parameters.value().to_dict()))
        if message_effect_id is not None:
            parameters.append(RequestParameter.from_input("message_effect_id", message_effect_id.value()))
        if allow_paid_broadcast is not None:
            parameters.append(RequestParameter.from_input("allow_paid_broadcast", allow_paid_broadcast.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        if suggested_post_parameters is not None:
            parameters.append(RequestParameter.from_input("suggested_post_parameters", suggested_post_parameters.value().copy()))
        if allow_sending_without_reply is not None:
            parameters.append(RequestParameter.from_input("allow_sending_without_reply", allow_sending_without_reply.value()))
        if reply_to_message_id is not None:
            parameters.append(RequestParameter.from_input("reply_to_message_id", reply_to_message_id.value()))
        var result = self._post_parameters_with_api_kwargs("send_invoice", parameters^, api_kwargs)
        return Message.de_json(result)

    def send_invoice(
        mut self,
        chat_id: Int,
        title: String,
        description: String,
        payload: String,
        currency: String,
        prices: List[LabeledPrice],
        provider_token: Optional[String] = None,
        start_parameter: Optional[String] = None,
        photo_url: Optional[String] = None,
        photo_size: Optional[Int] = None,
        photo_width: Optional[Int] = None,
        photo_height: Optional[Int] = None,
        need_name: Optional[Bool] = None,
        need_phone_number: Optional[Bool] = None,
        need_email: Optional[Bool] = None,
        need_shipping_address: Optional[Bool] = None,
        is_flexible: Optional[Bool] = None,
        disable_notification: Optional[Bool] = None,
        reply_markup: Optional[JsonDocument] = None,
        provider_data: Optional[JsonDocument] = None,
        send_phone_number_to_provider: Optional[Bool] = None,
        send_email_to_provider: Optional[Bool] = None,
        max_tip_amount: Optional[Int] = None,
        suggested_tip_amounts: Optional[List[Int]] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        message_effect_id: Optional[String] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None,
        suggested_post_parameters: Optional[JsonDocument] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_invoice(
            String(chat_id), title, description, payload, currency, prices, provider_token,
            start_parameter, photo_url, photo_size, photo_width, photo_height, need_name,
            need_phone_number, need_email, need_shipping_address, is_flexible,
            disable_notification, reply_markup, provider_data, send_phone_number_to_provider,
            send_email_to_provider, max_tip_amount, suggested_tip_amounts, protect_content,
            message_thread_id, reply_parameters, message_effect_id, allow_paid_broadcast,
            direct_messages_topic_id, suggested_post_parameters, allow_sending_without_reply,
            reply_to_message_id, api_kwargs,
        )

    def create_invoice_link(
        mut self,
        title: String,
        description: String,
        payload: String,
        currency: String,
        prices: List[LabeledPrice],
        provider_token: Optional[String] = None,
        max_tip_amount: Optional[Int] = None,
        suggested_tip_amounts: Optional[List[Int]] = None,
        provider_data: Optional[JsonDocument] = None,
        photo_url: Optional[String] = None,
        photo_size: Optional[Int] = None,
        photo_width: Optional[Int] = None,
        photo_height: Optional[Int] = None,
        need_name: Optional[Bool] = None,
        need_phone_number: Optional[Bool] = None,
        need_email: Optional[Bool] = None,
        need_shipping_address: Optional[Bool] = None,
        send_phone_number_to_provider: Optional[Bool] = None,
        send_email_to_provider: Optional[Bool] = None,
        is_flexible: Optional[Bool] = None,
        subscription_period: Optional[Int] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> String:
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("title", title))
        parameters.append(RequestParameter.from_input("description", description))
        parameters.append(RequestParameter.from_input("payload", payload))
        if provider_token is not None:
            parameters.append(RequestParameter.from_input("provider_token", provider_token.value()))
        parameters.append(RequestParameter.from_input("currency", currency))
        parameters.append(RequestParameter.from_input("prices", _bot_labeled_price_array(prices)))
        if max_tip_amount is not None:
            parameters.append(RequestParameter.from_input("max_tip_amount", max_tip_amount.value()))
        if suggested_tip_amounts is not None:
            parameters.append(RequestParameter.from_input("suggested_tip_amounts", _bot_integer_array(suggested_tip_amounts.value())))
        if provider_data is not None:
            var provider = provider_data.value().copy()
            if provider.nodes[provider.root].kind == JSON_STRING:
                parameters.append(RequestParameter.from_input("provider_data", provider.string_value(provider.root)))
            else:
                parameters.append(RequestParameter.from_input("provider_data", dumps_json(provider)))
        if photo_url is not None:
            parameters.append(RequestParameter.from_input("photo_url", photo_url.value()))
        if photo_size is not None:
            parameters.append(RequestParameter.from_input("photo_size", photo_size.value()))
        if photo_width is not None:
            parameters.append(RequestParameter.from_input("photo_width", photo_width.value()))
        if photo_height is not None:
            parameters.append(RequestParameter.from_input("photo_height", photo_height.value()))
        if need_name is not None:
            parameters.append(RequestParameter.from_input("need_name", need_name.value()))
        if need_phone_number is not None:
            parameters.append(RequestParameter.from_input("need_phone_number", need_phone_number.value()))
        if need_email is not None:
            parameters.append(RequestParameter.from_input("need_email", need_email.value()))
        if need_shipping_address is not None:
            parameters.append(RequestParameter.from_input("need_shipping_address", need_shipping_address.value()))
        if send_phone_number_to_provider is not None:
            parameters.append(RequestParameter.from_input("send_phone_number_to_provider", send_phone_number_to_provider.value()))
        if send_email_to_provider is not None:
            parameters.append(RequestParameter.from_input("send_email_to_provider", send_email_to_provider.value()))
        if is_flexible is not None:
            parameters.append(RequestParameter.from_input("is_flexible", is_flexible.value()))
        if subscription_period is not None:
            parameters.append(RequestParameter.from_input("subscription_period", subscription_period.value()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        var result = self._post_parameters_with_api_kwargs("create_invoice_link", parameters^, api_kwargs)
        return result.string_value(result.root)

    def edit_message_live_location(
        mut self,
        chat_id: Optional[String] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        latitude: Optional[Float64] = None,
        longitude: Optional[Float64] = None,
        reply_markup: Optional[JsonDocument] = None,
        horizontal_accuracy: Optional[Float64] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
        live_period: Optional[TimeDelta] = None,
        business_connection_id: Optional[String] = None,
        location: Optional[Location] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var parameters = List[RequestParameter]()
        if location is not None:
            var point = location.value().copy()
            parameters.append(RequestParameter.from_input("latitude", point.latitude))
            parameters.append(RequestParameter.from_input("longitude", point.longitude))
            if point.horizontal_accuracy is not None:
                parameters.append(RequestParameter.from_input("horizontal_accuracy", point.horizontal_accuracy.value()))
            if point.heading is not None:
                parameters.append(RequestParameter.from_input("heading", point.heading.value()))
            if point.proximity_alert_radius is not None:
                parameters.append(RequestParameter.from_input("proximity_alert_radius", point.proximity_alert_radius.value()))
            if point.live_period is not None:
                parameters.append(RequestParameter.from_input("live_period", Int(point.live_period.value().total_seconds())))
        else:
            if latitude is not None:
                parameters.append(RequestParameter.from_input("latitude", latitude.value()))
            if longitude is not None:
                parameters.append(RequestParameter.from_input("longitude", longitude.value()))
            if horizontal_accuracy is not None:
                parameters.append(RequestParameter.from_input("horizontal_accuracy", horizontal_accuracy.value()))
            if heading is not None:
                parameters.append(RequestParameter.from_input("heading", heading.value()))
            if proximity_alert_radius is not None:
                parameters.append(RequestParameter.from_input("proximity_alert_radius", proximity_alert_radius.value()))
            if live_period is not None:
                parameters.append(RequestParameter.from_input("live_period", Int(live_period.value().total_seconds())))
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        return self._post_edit_result("edit_message_live_location", parameters^, api_kwargs)

    def edit_message_live_location(
        mut self,
        chat_id: Optional[Int],
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        latitude: Optional[Float64] = None,
        longitude: Optional[Float64] = None,
        reply_markup: Optional[JsonDocument] = None,
        horizontal_accuracy: Optional[Float64] = None,
        heading: Optional[Int] = None,
        proximity_alert_radius: Optional[Int] = None,
        live_period: Optional[TimeDelta] = None,
        business_connection_id: Optional[String] = None,
        location: Optional[Location] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var normalized_chat_id: Optional[String] = None
        if chat_id is not None:
            normalized_chat_id = Optional[String](String(chat_id.value()))
        return self.edit_message_live_location(
            normalized_chat_id, message_id, inline_message_id, latitude, longitude,
            reply_markup, horizontal_accuracy, heading, proximity_alert_radius, live_period,
            business_connection_id, location, api_kwargs,
        )

    def stop_message_live_location(
        mut self,
        chat_id: Optional[String] = None,
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var parameters = List[RequestParameter]()
        if chat_id is not None:
            parameters.append(RequestParameter.from_input("chat_id", chat_id.value()))
        if message_id is not None:
            parameters.append(RequestParameter.from_input("message_id", message_id.value()))
        if inline_message_id is not None:
            parameters.append(RequestParameter.from_input("inline_message_id", inline_message_id.value()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        return self._post_edit_result("stop_message_live_location", parameters^, api_kwargs)

    def stop_message_live_location(
        mut self,
        chat_id: Optional[Int],
        message_id: Optional[Int] = None,
        inline_message_id: Optional[String] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> MessageEditResult:
        var normalized_chat_id: Optional[String] = None
        if chat_id is not None:
            normalized_chat_id = Optional[String](String(chat_id.value()))
        return self.stop_message_live_location(
            normalized_chat_id, message_id, inline_message_id, reply_markup,
            business_connection_id, api_kwargs,
        )

    def send_media_group(
        mut self,
        chat_id: String,
        media: List[InputMedia],
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        business_connection_id: Optional[String] = None,
        message_effect_id: Optional[String] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
    ) raises -> List[Message]:
        if reply_parameters is not None and (
            allow_sending_without_reply is not None or reply_to_message_id is not None
        ):
            raise Error("reply_parameters cannot be combined with reply convenience parameters")
        var request_media = List[InputMedia](copy=media)
        if caption is not None and caption.value().byte_length() > 0:
            for item in request_media:
                var item_caption = item.data.object_get(item.data.root, "caption")
                var item_entities = item.data.object_get(item.data.root, "caption_entities")
                var item_parse_mode = item.data.object_get(item.data.root, "parse_mode")
                var has_item_entities = False
                if item_entities != -1 and not item.data.is_null(item_entities):
                    if item.data.nodes[item_entities].kind == JSON_ARRAY:
                        has_item_entities = item.data.child_count(item_entities) > 0
                    else:
                        has_item_entities = True
                if (item_caption != -1 and not item.data.is_null(item_caption) and item.data.string_value(item_caption).byte_length() > 0) or has_item_entities or item_parse_mode != -1:
                    raise Error("You can only supply either group caption or media with captions")
            var first = request_media[0].copy()
            first.data.set_string(first.data.root, "caption", caption.value())
            if parse_mode is not None:
                first.data.set_string(first.data.root, "parse_mode", parse_mode.value())
            if caption_entities is not None:
                var entities = _bot_message_entity_array(caption_entities.value())
                var entities_node = first.data.copy_subtree_from(entities, entities.root)
                first.data.object_set(first.data.root, "caption_entities", entities_node)
            request_media[0] = first^  # Keep the caller's values unchanged.
        var resolved_reply_parameters = reply_parameters.copy()
        if reply_to_message_id is not None:
            var generated_reply = ReplyParameters(reply_to_message_id.value())
            if allow_sending_without_reply is not None:
                generated_reply.allow_sending_without_reply = allow_sending_without_reply
            resolved_reply_parameters = Optional[ReplyParameters](generated_reply^)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("media", request_media))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        if resolved_reply_parameters is not None:
            parameters.append(RequestParameter.from_input("reply_parameters", resolved_reply_parameters.value().to_dict()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        if message_effect_id is not None:
            parameters.append(RequestParameter.from_input("message_effect_id", message_effect_id.value()))
        if allow_paid_broadcast is not None:
            parameters.append(RequestParameter.from_input("allow_paid_broadcast", allow_paid_broadcast.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        var result = self._post_parameters_with_api_kwargs("send_media_group", parameters^, api_kwargs)
        return Message.de_list(result, result.root)

    def send_media_group(
        mut self,
        chat_id: Int,
        media: List[InputMedia],
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        message_thread_id: Optional[Int] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        business_connection_id: Optional[String] = None,
        message_effect_id: Optional[String] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
    ) raises -> List[Message]:
        return self.send_media_group(
            String(chat_id), media, disable_notification, protect_content,
            message_thread_id, reply_parameters, business_connection_id, message_effect_id,
            allow_paid_broadcast, direct_messages_topic_id, allow_sending_without_reply,
            reply_to_message_id, api_kwargs, caption, parse_mode, caption_entities,
        )

    def send_paid_media(
        mut self,
        chat_id: String,
        star_count: Int,
        media: List[InputPaidMedia],
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        show_caption_above_media: Optional[Bool] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        payload: Optional[String] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None,
        suggested_post_parameters: Optional[JsonDocument] = None,
        message_thread_id: Optional[Int] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        if reply_parameters is not None and (
            allow_sending_without_reply is not None or reply_to_message_id is not None
        ):
            raise Error("reply_parameters cannot be combined with reply convenience parameters")
        var resolved_reply_parameters = reply_parameters.copy()
        if reply_to_message_id is not None:
            var generated_reply = ReplyParameters(reply_to_message_id.value())
            if allow_sending_without_reply is not None:
                generated_reply.allow_sending_without_reply = allow_sending_without_reply
            resolved_reply_parameters = Optional[ReplyParameters](generated_reply^)
        var parameters = List[RequestParameter]()
        parameters.append(RequestParameter.from_input("chat_id", chat_id))
        parameters.append(RequestParameter.from_input("star_count", star_count))
        parameters.append(RequestParameter.from_input("media", media))
        if caption is not None:
            parameters.append(RequestParameter.from_input("caption", caption.value()))
        if parse_mode is not None:
            parameters.append(RequestParameter.from_input("parse_mode", parse_mode.value()))
        if caption_entities is not None:
            parameters.append(RequestParameter.from_input("caption_entities", _bot_message_entity_array(caption_entities.value())))
        if show_caption_above_media is not None:
            parameters.append(RequestParameter.from_input("show_caption_above_media", show_caption_above_media.value()))
        if disable_notification is not None:
            parameters.append(RequestParameter.from_input("disable_notification", disable_notification.value()))
        if protect_content is not None:
            parameters.append(RequestParameter.from_input("protect_content", protect_content.value()))
        if resolved_reply_parameters is not None:
            parameters.append(RequestParameter.from_input("reply_parameters", resolved_reply_parameters.value().to_dict()))
        if reply_markup is not None:
            parameters.append(RequestParameter.from_input("reply_markup", reply_markup.value().copy()))
        if business_connection_id is not None:
            parameters.append(RequestParameter.from_input("business_connection_id", business_connection_id.value()))
        if payload is not None:
            parameters.append(RequestParameter.from_input("payload", payload.value()))
        if allow_paid_broadcast is not None:
            parameters.append(RequestParameter.from_input("allow_paid_broadcast", allow_paid_broadcast.value()))
        if direct_messages_topic_id is not None:
            parameters.append(RequestParameter.from_input("direct_messages_topic_id", direct_messages_topic_id.value()))
        if suggested_post_parameters is not None:
            parameters.append(RequestParameter.from_input("suggested_post_parameters", suggested_post_parameters.value().copy()))
        if message_thread_id is not None:
            parameters.append(RequestParameter.from_input("message_thread_id", message_thread_id.value()))
        var result = self._post_parameters_with_api_kwargs("send_paid_media", parameters^, api_kwargs)
        return Message.de_json(result)

    def send_paid_media(
        mut self,
        chat_id: Int,
        star_count: Int,
        media: List[InputPaidMedia],
        caption: Optional[String] = None,
        parse_mode: Optional[String] = None,
        caption_entities: Optional[List[MessageEntity]] = None,
        show_caption_above_media: Optional[Bool] = None,
        disable_notification: Optional[Bool] = None,
        protect_content: Optional[Bool] = None,
        reply_parameters: Optional[ReplyParameters] = None,
        reply_markup: Optional[JsonDocument] = None,
        business_connection_id: Optional[String] = None,
        payload: Optional[String] = None,
        allow_paid_broadcast: Optional[Bool] = None,
        direct_messages_topic_id: Optional[Int] = None,
        suggested_post_parameters: Optional[JsonDocument] = None,
        message_thread_id: Optional[Int] = None,
        allow_sending_without_reply: Optional[Bool] = None,
        reply_to_message_id: Optional[Int] = None,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Message:
        return self.send_paid_media(
            String(chat_id), star_count, media, caption, parse_mode, caption_entities,
            show_caption_above_media, disable_notification, protect_content, reply_parameters,
            reply_markup, business_connection_id, payload, allow_paid_broadcast,
            direct_messages_topic_id, suggested_post_parameters, message_thread_id,
            allow_sending_without_reply, reply_to_message_id, api_kwargs,
        )
