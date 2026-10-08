#!/usr/bin/env mojo
#
# Native argument-parsing helpers from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Native helpers for argument coercion shared by Telegram models and Bot methods."""

from std.collections.optional import Optional
from std.collections import List

from telegram._linkpreviewoptions import LinkPreviewOptions
from telegram._telegramobject import TelegramJsonDecodable
from telegram._utils.json import JsonDocument


def parse_sequence_arg[T: Copyable](arg: List[T]) -> List[T]:
    """Copy an optional-sequence value into a new native list.

    Mojo has no runtime Sequence supertype or dynamically sized tuple, so this
    native overload accepts homogeneous Lists. Callers cannot mutate the
    original list through the returned value.
    """
    return List[T](copy=arg)


def parse_sequence_arg[T: Copyable](arg: Optional[List[T]]) -> List[T]:
    if arg is None:
        return List[T]()
    return List[T](copy=arg.value())


def de_json_optional[T: TelegramJsonDecodable](
    data: Optional[JsonDocument],
) raises -> Optional[T]:
    """Decode one optional JSON object through a model's static protocol."""
    if data is None:
        return None
    return Optional[T](T.de_json(data.value().copy()))


def de_list_optional[T: TelegramJsonDecodable](
    data: Optional[JsonDocument],
) raises -> List[T]:
    """Decode an optional JSON array, returning an empty list for null input."""
    if data is None:
        return List[T]()
    var document = data.value().copy()
    return T.de_list(document.copy(), document.root)


def parse_lpo_and_dwpp(
    disable_web_page_preview: Optional[Bool],
    link_preview_options: Optional[LinkPreviewOptions],
) raises -> Optional[LinkPreviewOptions]:
    """Resolve the deprecated preview Boolean into the replacement options value."""
    if (
        disable_web_page_preview is not None
        and disable_web_page_preview.value()
        and link_preview_options is not None
    ):
        raise Error(
            "Parameters `disable_web_page_preview` and `link_preview_options` are mutually exclusive."
        )
    if disable_web_page_preview is not None:
        return Optional[LinkPreviewOptions](
            LinkPreviewOptions(disable_web_page_preview.value())
        )
    return link_preview_options.copy()
