#!/usr/bin/env mojo
#
# Native translation of python-telegram-bot v22.8 _files/inputstorycontent.py.
# LGPL-3.0-or-later; see LICENSE.

"""Tagged photo/video story-upload values."""

from std.collections import List
from std.collections.optional import Optional
from std.pathlib import Path

from telegram import constants
from telegram._files.inputfile import InputFile
from telegram._utils.datetime import TimeDelta, to_timedelta
from telegram._utils.files import ParsedFileInput, parse_file_input
from telegram._utils.json import JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _copy_api_kwargs(value: Optional[JsonDocument]) -> JsonDocument:
    if value is None:
        return empty_json_object()
    return value.value().copy()


struct InputStoryContent(Copyable):
    """One story photo or video input with a Bot API type discriminator.

    The upstream Python photo/video subclasses are represented as static
    constructors that return this tagged value. File inputs are parsed in
    local mode and uploads are prepared for multipart attachment.
    """

    comptime PHOTO = constants.InputStoryContentType.PHOTO.value
    comptime VIDEO = constants.InputStoryContentType.VIDEO.value

    var type: String
    var photo: Optional[ParsedFileInput]
    var video: Optional[ParsedFileInput]
    var duration: Optional[TimeDelta]
    var cover_frame_timestamp: Optional[TimeDelta]
    var is_animation: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, type: String, *, api_kwargs: Optional[JsonDocument] = None):
        self.type = type.copy()
        self.photo = None
        self.video = None
        self.duration = None
        self.cover_frame_timestamp = None
        self.is_animation = None
        self.api_kwargs = _copy_api_kwargs(api_kwargs)

    def __copyinit__(out self, existing: Self):
        self.type = existing.type.copy()
        self.photo = existing.photo.copy()
        self.video = existing.video.copy()
        self.duration = existing.duration.copy()
        self.cover_frame_timestamp = existing.cover_frame_timestamp.copy()
        self.is_animation = existing.is_animation
        self.api_kwargs = existing.api_kwargs.copy()

    @staticmethod
    def _photo_with_input(
        file_input: ParsedFileInput, api_kwargs: Optional[JsonDocument]
    ) -> Self:
        var result = Self(Self.PHOTO, api_kwargs=api_kwargs)
        result.photo = Optional[ParsedFileInput](file_input.copy())
        return result^

    @staticmethod
    def photo_content(photo: String, *, api_kwargs: Optional[JsonDocument] = None) raises -> Self:
        return Self._photo_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def photo_content(photo: Path, *, api_kwargs: Optional[JsonDocument] = None) raises -> Self:
        return Self._photo_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def photo_content(photo: InputFile, *, api_kwargs: Optional[JsonDocument] = None) -> Self:
        return Self._photo_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def photo_content(photo: List[UInt8], *, api_kwargs: Optional[JsonDocument] = None) -> Self:
        return Self._photo_with_input(
            parse_file_input(photo, attach=True, local_mode=True), api_kwargs
        )

    @staticmethod
    def _video_with_input(
        file_input: ParsedFileInput,
        duration: Optional[Float64],
        cover_frame_timestamp: Optional[Float64],
        is_animation: Optional[Bool],
        api_kwargs: Optional[JsonDocument],
    ) -> Self:
        var result = Self(Self.VIDEO, api_kwargs=api_kwargs)
        result.video = Optional[ParsedFileInput](file_input.copy())
        if duration is not None:
            result.duration = Optional[TimeDelta](to_timedelta(duration.value()))
        if cover_frame_timestamp is not None:
            result.cover_frame_timestamp = Optional[TimeDelta](
                to_timedelta(cover_frame_timestamp.value())
            )
        result.is_animation = is_animation
        return result^

    @staticmethod
    def video_content(
        video: String,
        duration: Optional[Float64] = None,
        cover_frame_timestamp: Optional[Float64] = None,
        is_animation: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        return Self._video_with_input(
            parse_file_input(video, attach=True, local_mode=True),
            duration,
            cover_frame_timestamp,
            is_animation,
            api_kwargs,
        )

    @staticmethod
    def video_content(
        video: Path,
        duration: Optional[Float64] = None,
        cover_frame_timestamp: Optional[Float64] = None,
        is_animation: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) raises -> Self:
        return Self._video_with_input(
            parse_file_input(video, attach=True, local_mode=True),
            duration,
            cover_frame_timestamp,
            is_animation,
            api_kwargs,
        )

    @staticmethod
    def video_content(
        video: InputFile,
        duration: Optional[Float64] = None,
        cover_frame_timestamp: Optional[Float64] = None,
        is_animation: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) -> Self:
        return Self._video_with_input(
            parse_file_input(video, attach=True, local_mode=True),
            duration,
            cover_frame_timestamp,
            is_animation,
            api_kwargs,
        )

    @staticmethod
    def video_content(
        video: List[UInt8],
        duration: Optional[Float64] = None,
        cover_frame_timestamp: Optional[Float64] = None,
        is_animation: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) -> Self:
        return Self._video_with_input(
            parse_file_input(video, attach=True, local_mode=True),
            duration,
            cover_frame_timestamp,
            is_animation,
            api_kwargs,
        )

    @staticmethod
    def video_with_native_durations(
        video: ParsedFileInput,
        duration: Optional[TimeDelta] = None,
        cover_frame_timestamp: Optional[TimeDelta] = None,
        is_animation: Optional[Bool] = None,
        *,
        api_kwargs: Optional[JsonDocument] = None,
    ) -> Self:
        var result = Self(Self.VIDEO, api_kwargs=api_kwargs)
        result.video = Optional[ParsedFileInput](video.copy())
        result.duration = duration.copy()
        result.cover_frame_timestamp = cover_frame_timestamp.copy()
        result.is_animation = is_animation
        return result^

    def upload_file(self) -> Optional[InputFile]:
        if self.type == Self.PHOTO and self.photo is not None:
            var parsed = self.photo.value().copy()
            if parsed.kind == ParsedFileInput.UPLOAD:
                return Optional[InputFile](parsed.input_file.value().copy())
        if self.type == Self.VIDEO and self.video is not None:
            var parsed = self.video.value().copy()
            if parsed.kind == ParsedFileInput.UPLOAD:
                return Optional[InputFile](parsed.input_file.value().copy())
        return None

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "type", self.type)

        var field_name = String()
        var field: Optional[ParsedFileInput] = None
        if self.type == Self.PHOTO:
            field_name = "photo"
            field = self.photo.copy()
        elif self.type == Self.VIDEO:
            field_name = "video"
            field = self.video.copy()

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
                raise Error("A non-local Path is not JSON-serializable as InputStoryContent")
            else:
                raise Error("InputStoryContent has an unknown file-input variant")

        if self.duration is not None:
            result.set_number(result.root, "duration", self.duration.value().seconds_json_number())
        if self.cover_frame_timestamp is not None:
            result.set_number(
                result.root,
                "cover_frame_timestamp",
                self.cover_frame_timestamp.value().seconds_json_number(),
            )
        if self.is_animation is not None:
            result.set_boolean(result.root, "is_animation", self.is_animation.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

