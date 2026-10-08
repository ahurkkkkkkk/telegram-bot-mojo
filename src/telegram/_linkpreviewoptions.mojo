#!/usr/bin/env mojo
#
# Native LinkPreviewOptions translation from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Link preview configuration passed to Telegram Bot API methods."""

from telegram._telegramobject import TelegramJsonObject
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _link_preview_kwargs(data: JsonDocument) raises -> JsonDocument:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error("LinkPreviewOptions JSON document has no root")
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error("LinkPreviewOptions JSON value is not an object")
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        if (
            key != "is_disabled"
            and key != "url"
            and key != "prefer_small_media"
            and key != "prefer_large_media"
            and key != "show_above_text"
        ):
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct LinkPreviewOptions(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Optional link-preview fields with unknown API data retained."""

    var is_disabled: Optional[Bool]
    var url: Optional[String]
    var prefer_small_media: Optional[Bool]
    var prefer_large_media: Optional[Bool]
    var show_above_text: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        is_disabled: Optional[Bool] = None,
        url: Optional[String] = None,
        prefer_small_media: Optional[Bool] = None,
        prefer_large_media: Optional[Bool] = None,
        show_above_text: Optional[Bool] = None,
    ):
        self.is_disabled = is_disabled
        self.url = url
        self.prefer_small_media = prefer_small_media
        self.prefer_large_media = prefer_large_media
        self.show_above_text = show_above_text
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        is_disabled: Optional[Bool],
        url: Optional[String],
        prefer_small_media: Optional[Bool],
        prefer_large_media: Optional[Bool],
        show_above_text: Optional[Bool],
        *,
        api_kwargs: JsonDocument,
    ):
        self.is_disabled = is_disabled
        self.url = url
        self.prefer_small_media = prefer_small_media
        self.prefer_large_media = prefer_large_media
        self.show_above_text = show_above_text
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.is_disabled = existing.is_disabled
        self.url = existing.url
        self.prefer_small_media = existing.prefer_small_media
        self.prefer_large_media = existing.prefer_large_media
        self.show_above_text = existing.show_above_text
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.is_disabled == other.is_disabled
            and self.url == other.url
            and self.prefer_small_media == other.prefer_small_media
            and self.prefer_large_media == other.prefer_large_media
            and self.show_above_text == other.show_above_text
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        if self.is_disabled is None:
            hasher.update(String("None\0").as_bytes())
        else:
            hasher.update(String("Some\0").as_bytes())
            if self.is_disabled.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        if self.url is None:
            hasher.update(String("\0None\0").as_bytes())
        else:
            hasher.update(String("\0Some\0").as_bytes())
            hasher.update(self.url.value().as_bytes())
        if self.prefer_small_media is None:
            hasher.update(String("\0None\0").as_bytes())
        else:
            hasher.update(String("\0Some\0").as_bytes())
            if self.prefer_small_media.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        if self.prefer_large_media is None:
            hasher.update(String("\0None\0").as_bytes())
        else:
            hasher.update(String("\0Some\0").as_bytes())
            if self.prefer_large_media.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())
        if self.show_above_text is None:
            hasher.update(String("\0None").as_bytes())
        else:
            hasher.update(String("\0Some\0").as_bytes())
            if self.show_above_text.value():
                hasher.update(String("true").as_bytes())
            else:
                hasher.update(String("false").as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.is_disabled is not None:
            result.set_boolean(result.root, "is_disabled", self.is_disabled.value())
        if self.prefer_large_media is not None:
            result.set_boolean(result.root, "prefer_large_media", self.prefer_large_media.value())
        if self.prefer_small_media is not None:
            result.set_boolean(result.root, "prefer_small_media", self.prefer_small_media.value())
        if self.show_above_text is not None:
            result.set_boolean(result.root, "show_above_text", self.show_above_text.value())
        if self.url is not None:
            result.set_string(result.root, "url", self.url.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> LinkPreviewOptions:
        if data.root < 0 or data.root >= len(data.nodes):
            raise Error("LinkPreviewOptions JSON document has no root")
        if data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("LinkPreviewOptions JSON value is not an object")

        var is_disabled: Optional[Bool] = None
        var is_disabled_index = data.object_get(data.root, "is_disabled")
        if is_disabled_index != -1 and not data.is_null(is_disabled_index):
            is_disabled = Optional[Bool](data.boolean_value(is_disabled_index))

        var url: Optional[String] = None
        var url_index = data.object_get(data.root, "url")
        if url_index != -1 and not data.is_null(url_index):
            url = Optional[String](data.string_value(url_index))

        var prefer_small_media: Optional[Bool] = None
        var small_index = data.object_get(data.root, "prefer_small_media")
        if small_index != -1 and not data.is_null(small_index):
            prefer_small_media = Optional[Bool](data.boolean_value(small_index))

        var prefer_large_media: Optional[Bool] = None
        var large_index = data.object_get(data.root, "prefer_large_media")
        if large_index != -1 and not data.is_null(large_index):
            prefer_large_media = Optional[Bool](data.boolean_value(large_index))

        var show_above_text: Optional[Bool] = None
        var above_index = data.object_get(data.root, "show_above_text")
        if above_index != -1 and not data.is_null(above_index):
            show_above_text = Optional[Bool](data.boolean_value(above_index))

        return LinkPreviewOptions(
            is_disabled,
            url,
            prefer_small_media,
            prefer_large_media,
            show_above_text,
            api_kwargs=_link_preview_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[LinkPreviewOptions]:
        var items = data.array_documents(array_index)
        var result = List[LinkPreviewOptions]()
        for index in range(len(items)):
            result.append(LinkPreviewOptions.de_json(items[index].copy()))
        return result^
