"""Internal helpers shared by the Telegram client modules."""

from .defaultvalue import (
    DEFAULT_FALSE,
    DEFAULT_NONE,
    DEFAULT_TRUE,
    DEFAULT_20,
    DEFAULT_IP,
    DEFAULT_80,
    DefaultValue,
    get_value,
    is_truthy,
)
from .strings import TextEncoding, to_camel_case
from .usernames import get_full_name, get_link, get_name
from .entities import parse_message_entities, parse_message_entity
from .datetime import Date, TimeDelta, get_timedelta_value, to_timedelta
from .json import JsonDocument, JsonNode, dumps_json, parse_json
from .json_model import (
    empty_json_object,
    optional_string_field_to_json,
    parse_optional_string_field,
    parse_string_field,
    string_field_to_json,
)
from .files import ParsedFileInput, guess_file_name, is_local_file, load_file, parse_file_input
