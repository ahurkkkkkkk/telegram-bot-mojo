#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _files/inputprofilephoto.py.
# LGPL-3.0-or-later; see LICENSE.

"""Tagged static and animated profile-photo inputs."""

from std.collections import List
from std.collections.optional import Optional
from std.pathlib import Path

from telegram import constants
from telegram._files.inputfile import InputFile
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.files import ParsedFileInput, parse_file_input
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _copy_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


struct InputProfilePhoto(Copyable):
    """One static or animated profile-photo value.

    Python's runtime subclass factory is represented by a tagged native value.
    Use ``static`` or ``animated`` to create the corresponding upload variant.
    """

    comptime STATIC = constants.InputProfilePhotoType.STATIC.value
    comptime ANIMATED = constants.InputProfilePhotoType.ANIMATED.value

    var type: String
    var photo: Optional[ParsedFileInput]
    var animation: Optional[ParsedFileInput]
    var main_frame_timestamp: Optional[TimeDelta]
    var api_kwargs: JsonDocument

    def __init__(out self, type: String, *, api_kwargs: Optional[JsonDocument] = None):
        self.type = type.copy()
        self.photo = None
        self.animation = None
        self.main_frame_timestamp = None
        self.api_kwargs = _copy_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.photo = existing.photo.copy()
        self.animation = existing.animation.copy()
        self.main_frame_timestamp = existing.main_frame_timestamp.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    @staticmethod
    def _static_with_input(
        file_input: ParsedFileInput, api_kwargs: Optional[JsonDocument]
    ) -> Self:
        var result = Self(Self.STATIC, api_kwargs=api_kwargs)
        result.photo = Optional[ParsedFileInput](file_input.copy())
        return result^

    @staticmethod
    def static(photo: String, *, api_kwargs: Optional[JsonDocument] = None) raises -> Self:
        return Self._static_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def static(photo: Path, *, api_kwargs: Optional[JsonDocument] = None) raises -> Self:
        return Self._static_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def static(photo: InputFile, *, api_kwargs: Optional[JsonDocument] = None) -> Self:
        return Self._static_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def static(photo: List[UInt8], *, api_kwargs: Optional[JsonDocument] = None) -> Self:
        return Self._static_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def _animated_with_input(
        file_input: ParsedFileInput,
        timestamp: Optional[TimeDelta],
        api_kwargs: Optional[JsonDocument],
    ) -> Self:
        var result = Self(Self.ANIMATED, api_kwargs=api_kwargs)
        result.animation = Optional[ParsedFileInput](file_input.copy())
        result.main_frame_timestamp = timestamp.copy()
        return result^

    @staticmethod
    def animated(
        animation: String,
        main_frame_timestamp: Optional[Float64] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var timestamp: Optional[TimeDelta] = None
        if main_frame_timestamp is not None:
            timestamp = Optional[TimeDelta](to_timedelta(main_frame_timestamp.value()))
        return Self._animated_with_input(
            parse_file_input(animation, attach=True, local_mode=True), timestamp, api_kwargs
        )

    @staticmethod
    def animated(
        animation: Path,
        main_frame_timestamp: Optional[Float64] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        var timestamp: Optional[TimeDelta] = None
        if main_frame_timestamp is not None:
            timestamp = Optional[TimeDelta](to_timedelta(main_frame_timestamp.value()))
        return Self._animated_with_input(
            parse_file_input(animation, attach=True, local_mode=True), timestamp, api_kwargs
        )

    @staticmethod
    def animated(
        animation: InputFile,
        main_frame_timestamp: Optional[Float64] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) -> Self:
        var timestamp: Optional[TimeDelta] = None
        if main_frame_timestamp is not None:
            timestamp = Optional[TimeDelta](to_timedelta(main_frame_timestamp.value()))
        return Self._animated_with_input(
            parse_file_input(animation, attach=True, local_mode=True), timestamp, api_kwargs
        )

    @staticmethod
    def animated(
        animation: List[UInt8],
        main_frame_timestamp: Optional[Float64] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) -> Self:
        var timestamp: Optional[TimeDelta] = None
        if main_frame_timestamp is not None:
            timestamp = Optional[TimeDelta](to_timedelta(main_frame_timestamp.value()))
        return Self._animated_with_input(
            parse_file_input(animation, attach=True, local_mode=True), timestamp, api_kwargs
        )

    def upload_file(self) -> Optional[InputFile]:
        if self.type == Self.STATIC and self.photo is not None:
            var parsed = self.photo.value().copy()
            if parsed.kind == ParsedFileInput.UPLOAD:
                return Optional[InputFile](parsed.input_file.value().copy())
        if self.type == Self.ANIMATED and self.animation is not None:
            var parsed = self.animation.value().copy()
            if parsed.kind == ParsedFileInput.UPLOAD:
                return Optional[InputFile](parsed.input_file.value().copy())
        return None

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)

        var field_name = String()
        var field: Optional[ParsedFileInput] = None
        if self.type == Self.STATIC:
            field_name = "photo"
            field = self.photo.copy()
        elif self.type == Self.ANIMATED:
            field_name = "animation"
            field = self.animation.copy()

        if field is not None:
            var parsed = field.value().copy()
            if parsed.kind == ParsedFileInput.FILE_ID:
                result.set_string(result.root, field_name, parsed.file_id.value())
            elif parsed.kind == ParsedFileInput.UPLOAD:
                var file = parsed.input_file.value().copy()
                if file.attach_uri is None:
                    result.set_null(result.root, field_name)
                else:
                    result.set_string(result.root, field_name, file.attach_uri.value())
            elif parsed.kind == ParsedFileInput.PATH:
                raise Error("A non-local Path is not JSON-serializable as an InputProfilePhoto")
            else:
                raise Error("InputProfilePhoto has an unknown file-input variant")

        if self.type == Self.ANIMATED and self.main_frame_timestamp is not None:
            result.set_number(
                result.root,
                "main_frame_timestamp",
                self.main_frame_timestamp.value().seconds_json_number(),
            )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

