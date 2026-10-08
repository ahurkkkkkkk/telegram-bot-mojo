#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 InlineQueryResultsButton.
# LGPL-3.0-or-later; see LICENSE.

"""The optional button displayed above inline query results."""

from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram import constants
from telegram._telegramobject import TelegramJsonObject
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object
from telegram._webappinfo import WebAppInfo


struct InlineQueryResultsButton(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A label with either a Web App or a deep-link start parameter."""

    comptime MIN_START_PARAMETER_LENGTH = constants.InlineQueryResultsButtonLimit.MIN_START_PARAMETER_LENGTH.value
    comptime MAX_START_PARAMETER_LENGTH = constants.InlineQueryResultsButtonLimit.MAX_START_PARAMETER_LENGTH.value

    var text: String
    var web_app: Optional[WebAppInfo]
    var start_parameter: Optional[String]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        text: String,
        web_app: Optional[WebAppInfo] = None,
        start_parameter: Optional[String] = None,
    ):
        self.text = text.copy()
        self.web_app = web_app.copy()
        self.start_parameter = start_parameter
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        text: String,
        web_app: Optional[WebAppInfo] = None,
        start_parameter: Optional[String] = None,
        *,
        api_kwargs: JsonDocument,
    ):
        self.text = text.copy()
        self.web_app = web_app.copy()
        self.start_parameter = start_parameter
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.text = existing.text.copy()
        self.web_app = existing.web_app.copy()
        self.start_parameter = existing.start_parameter
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if self.text != other.text or self.start_parameter != other.start_parameter:
            return False
        if self.web_app is None or other.web_app is None:
            return self.web_app is None and other.web_app is None
        return self.web_app.value() == other.web_app.value()

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(self.text.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.web_app is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(self.web_app.value().url.as_bytes())
        hasher.update(String("\0").as_bytes())
        if self.start_parameter is None:
            hasher.update(String("none").as_bytes())
        else:
            hasher.update(self.start_parameter.value().as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "text", self.text)
        if self.web_app is not None:
            var web_app = self.web_app.value().to_dict(recursive=recursive)
            var web_app_node = result.copy_subtree_from(web_app, web_app.root)
            result.object_set(result.root, "web_app", web_app_node)
        if self.start_parameter is not None:
            result.set_string(result.root, "start_parameter", self.start_parameter.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("InlineQueryResultsButton JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InlineQueryResultsButton JSON value is not an object")
        var text_index = data.object_get(data.root, "text")
        if text_index == -1:
            raise Error("InlineQueryResultsButton JSON object is missing text")
        var text = data.string_value(text_index)
        var web_app: Optional[WebAppInfo] = None
        var web_app_index = data.object_get(data.root, "web_app")
        if web_app_index != -1 and not data.is_null(web_app_index):
            var web_app_document = JsonDocument()
            web_app_document.root = web_app_document.copy_subtree_from(data, web_app_index)
            web_app = Optional[WebAppInfo](WebAppInfo.de_json(web_app_document))
        var start_parameter: Optional[String] = None
        var start_parameter_index = data.object_get(data.root, "start_parameter")
        if start_parameter_index != -1 and not data.is_null(start_parameter_index):
            start_parameter = Optional[String](data.string_value(start_parameter_index))
        var api_kwargs = empty_json_object()
        var child = data.nodes[data.root].first_child
        while child != -1:
            var key = data.nodes[child].name
            if key != "text" and key != "web_app" and key != "start_parameter":
                var copied = api_kwargs.copy_subtree_from(data, child)
                api_kwargs.object_set(api_kwargs.root, key.copy(), copied)
            child = data.nodes[child].next_sibling
        return InlineQueryResultsButton(
            text,
            web_app,
            start_parameter,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(InlineQueryResultsButton.de_json(items[index].copy()))
        return result^
