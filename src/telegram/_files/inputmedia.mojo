#!/usr/bin/env mojo
#
# Native request-media values translated from python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Input media records and upload attachments for Bot API requests."""

from std.collections import List
from std.collections.optional import Optional
from std.pathlib import Path

from telegram._files.inputfile import InputFile
from telegram._files.animation import Animation
from telegram._files.audio import Audio
from telegram._files.document import Document
from telegram._files.photosize import PhotoSize
from telegram._files.sticker import Sticker
from telegram._files.video import Video
from telegram._utils.files import ParsedFileInput, parse_file_input
from telegram._utils.json import JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


struct _InputMediaPayload(Copyable):
    var data: JsonDocument
    var uploads: List[InputFile]

    def __init__(out self, data: JsonDocument, uploads: List[InputFile]):
        self.data = data.copy()
        self.uploads = List[InputFile](copy=uploads)

    def __copyinit__(out self, existing: Self):
        self.data = existing.data.copy()
        self.uploads = List[InputFile](copy=existing.uploads)


def _input_media_write_file(
    mut data: JsonDocument,
    field: String,
    source: ParsedFileInput,
    mut uploads: List[InputFile],
) raises:
    if source.kind == ParsedFileInput.FILE_ID:
        data.set_string(data.root, field, source.file_id.value())
        return
    if source.kind == ParsedFileInput.UPLOAD:
        var upload = source.input_file.value().copy()
        if upload.attach_uri is None:
            upload = InputFile(upload.input_file_content, Optional[String](upload.filename), True)
        if upload.attach_uri is None:
            raise Error("Input media upload has no multipart attachment URI")
        data.set_string(data.root, field, upload.attach_uri.value())
        uploads.append(upload^)
        return
    if source.kind == ParsedFileInput.PATH:
        raise Error("A non-local Path must be read before media serialization")
    raise Error("Input media has an unknown file-input variant")


def _input_media_payload(
    media_type: String,
    media: ParsedFileInput,
    fields: Optional[JsonDocument],
    api_kwargs: Optional[JsonDocument],
) raises -> _InputMediaPayload:
    var data = empty_json_object()
    var uploads = List[InputFile]()
    data.set_string(data.root, "type", media_type)
    _input_media_write_file(data, "media", media, uploads)
    if fields is not None:
        var extra_fields = fields.value().copy()
        if extra_fields.root < 0 or extra_fields.root >= len(extra_fields.nodes) or extra_fields.nodes[extra_fields.root].kind != JSON_OBJECT:
            raise Error("Input media fields must be a JSON object")
        data.merge_object(data.root, extra_fields, extra_fields.root)
    if api_kwargs is not None:
        var extras = api_kwargs.value().copy()
        if extras.root < 0 or extras.root >= len(extras.nodes) or extras.nodes[extras.root].kind != JSON_OBJECT:
            raise Error("Input media api_kwargs must be a JSON object")
        data.merge_object(data.root, extras, extras.root)
    return _InputMediaPayload(data, uploads)


def _input_media_fields_payload(
    media_type: String,
    fields: JsonDocument,
    api_kwargs: Optional[JsonDocument],
) raises -> _InputMediaPayload:
    var data = empty_json_object()
    var uploads = List[InputFile]()
    data.set_string(data.root, "type", media_type)
    var extra_fields = fields.copy()
    if extra_fields.root < 0 or extra_fields.root >= len(extra_fields.nodes) or extra_fields.nodes[extra_fields.root].kind != JSON_OBJECT:
        raise Error("Input media fields must be a JSON object")
    data.merge_object(data.root, extra_fields, extra_fields.root)
    if api_kwargs is not None:
        var extras = api_kwargs.value().copy()
        if extras.root < 0 or extras.root >= len(extras.nodes) or extras.nodes[extras.root].kind != JSON_OBJECT:
            raise Error("Input media api_kwargs must be a JSON object")
        data.merge_object(data.root, extras, extras.root)
    return _InputMediaPayload(data, uploads)


struct InputMedia(Copyable):
    """Tagged input media item with serialized fields and multipart file parts.

    The tagged representation keeps native media values copyable while allowing
    the request layer to build ``attach://`` references for every upload.
    ``fields`` carries type-specific optional Bot API fields, including caption,
    entities, thumbnail, dimensions, and playback options.
    """

    var data: JsonDocument
    var uploads: List[InputFile]

    def __init__(out self, media_type: String, fields: JsonDocument, api_kwargs: Optional[JsonDocument] = None) raises:
        var payload = _input_media_fields_payload(media_type, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: ParsedFileInput, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var prepared = media.copy()
        if prepared.kind == ParsedFileInput.UPLOAD:
            var upload = prepared.input_file.value().copy()
            if upload.attach_uri is None:
                upload = InputFile(upload.input_file_content, Optional[String](upload.filename), True)
            prepared = ParsedFileInput(upload)
        var payload = _input_media_payload(media_type, prepared, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: Path, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: List[UInt8], fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __copyinit__(out self, existing: Self):
        self.data = existing.data.copy()
        self.uploads = List[InputFile](copy=existing.uploads)

    def with_file_field(self, field: String, file: ParsedFileInput) raises -> Self:
        var result = self.copy()
        var data = result.data.copy()
        var uploads = List[InputFile](copy=result.uploads)
        _input_media_write_file(data, field, file, uploads)
        result.data = data^
        result.uploads = uploads^
        return result^

    def to_dict(self, recursive: Bool = True) -> JsonDocument:
        return self.data.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.data.copy())

    def upload_files(self) -> List[InputFile]:
        return List[InputFile](copy=self.uploads)


struct InputPaidMedia(Copyable):
    """Tagged paid-media item with upload-aware Bot API serialization."""

    var data: JsonDocument
    var uploads: List[InputFile]

    def __init__(out self, media_type: String, media: ParsedFileInput, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var prepared = media.copy()
        if prepared.kind == ParsedFileInput.UPLOAD:
            var upload = prepared.input_file.value().copy()
            if upload.attach_uri is None:
                upload = InputFile(upload.input_file_content, Optional[String](upload.filename), True)
            prepared = ParsedFileInput(upload)
        var payload = _input_media_payload(media_type, prepared, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: Path, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __init__(out self, media_type: String, media: List[UInt8], fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises:
        var parsed = parse_file_input(media, attach=True, local_mode=False)
        var payload = _input_media_payload(media_type, parsed, fields, api_kwargs)
        self.data = payload.data.copy()
        self.uploads = List[InputFile](copy=payload.uploads)

    def __copyinit__(out self, existing: Self):
        self.data = existing.data.copy()
        self.uploads = List[InputFile](copy=existing.uploads)

    def with_file_field(self, field: String, file: ParsedFileInput) raises -> Self:
        var result = self.copy()
        var data = result.data.copy()
        var uploads = List[InputFile](copy=result.uploads)
        _input_media_write_file(data, field, file, uploads)
        result.data = data^
        result.uploads = uploads^
        return result^

    def to_dict(self, recursive: Bool = True) -> JsonDocument:
        return self.data.copy()

    def to_json(self) raises -> String:
        return dumps_json(self.data.copy())

    def upload_files(self) -> List[InputFile]:
        return List[InputFile](copy=self.uploads)


def InputMediaPhoto(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("photo", media, fields, api_kwargs)


def InputMediaPhoto(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("photo", media, fields, api_kwargs)


def InputMediaPhoto(media: PhotoSize, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("photo", media.file_id, fields, api_kwargs)


def InputMediaAudio(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("audio", media, fields, api_kwargs)


def InputMediaAudio(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("audio", media, fields, api_kwargs)


def InputMediaAudio(media: Audio, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    var model_fields = empty_json_object()
    var audio_duration = media.duration.copy()
    if audio_duration.microseconds == 0:
        model_fields.set_number(
            model_fields.root,
            "duration",
            String(audio_duration.days * 86400 + audio_duration.seconds),
        )
    else:
        model_fields.set_number(model_fields.root, "duration", audio_duration.seconds_json_number())
    if media.performer is not None:
        model_fields.set_string(model_fields.root, "performer", media.performer.value())
    if media.title is not None:
        model_fields.set_string(model_fields.root, "title", media.title.value())
    if fields is not None:
        var overrides = fields.value().copy()
        model_fields.merge_object(model_fields.root, overrides, overrides.root)
    return InputMedia("audio", media.file_id, Optional[JsonDocument](model_fields^), api_kwargs)


def InputMediaDocument(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("document", media, fields, api_kwargs)


def InputMediaDocument(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("document", media, fields, api_kwargs)


def InputMediaDocument(media: Document, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("document", media.file_id, fields, api_kwargs)


def InputMediaVideo(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("video", media, fields, api_kwargs)


def InputMediaVideo(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("video", media, fields, api_kwargs)


def InputMediaVideo(media: Video, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("video", media.file_id, fields, api_kwargs)


def InputMediaAnimation(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("animation", media, fields, api_kwargs)


def InputMediaAnimation(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("animation", media, fields, api_kwargs)


def InputMediaAnimation(media: Animation, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("animation", media.file_id, fields, api_kwargs)


def InputMediaSticker(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("sticker", media, fields, api_kwargs)


def InputMediaSticker(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("sticker", media, fields, api_kwargs)


def InputMediaSticker(media: Sticker, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputMedia:
    return InputMedia("sticker", media.file_id, fields, api_kwargs)


def InputMediaLivePhoto(
    media: String,
    photo: String,
    fields: Optional[JsonDocument] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputMedia:
    var result = InputMedia("live_photo", media, fields, api_kwargs)
    return result.with_file_field("photo", parse_file_input(photo, attach=True, local_mode=False))


def InputMediaLivePhoto(
    media: Video,
    photo: PhotoSize,
    fields: Optional[JsonDocument] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputMedia:
    var result = InputMedia("live_photo", media.file_id, fields, api_kwargs)
    return result.with_file_field("photo", parse_file_input(photo.file_id, attach=True, local_mode=False))


def InputMediaLivePhoto(
    media: InputFile,
    photo: InputFile,
    fields: Optional[JsonDocument] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputMedia:
    var result = InputMedia("live_photo", media, fields, api_kwargs)
    return result.with_file_field("photo", parse_file_input(photo, attach=True, local_mode=False))


def InputMediaLocation(
    latitude: Float64,
    longitude: Float64,
    horizontal_accuracy: Optional[Float64] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputMedia:
    var fields = empty_json_object()
    fields.set_number(fields.root, "latitude", String(latitude))
    fields.set_number(fields.root, "longitude", String(longitude))
    if horizontal_accuracy is not None:
        fields.set_number(fields.root, "horizontal_accuracy", String(horizontal_accuracy.value()))
    return InputMedia("location", fields, api_kwargs)


def InputMediaVenue(
    latitude: Float64,
    longitude: Float64,
    title: String,
    address: String,
    foursquare_id: Optional[String] = None,
    foursquare_type: Optional[String] = None,
    google_place_id: Optional[String] = None,
    google_place_type: Optional[String] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputMedia:
    var fields = empty_json_object()
    fields.set_number(fields.root, "latitude", String(latitude))
    fields.set_number(fields.root, "longitude", String(longitude))
    fields.set_string(fields.root, "title", title)
    fields.set_string(fields.root, "address", address)
    if foursquare_id is not None:
        fields.set_string(fields.root, "foursquare_id", foursquare_id.value())
    if foursquare_type is not None:
        fields.set_string(fields.root, "foursquare_type", foursquare_type.value())
    if google_place_id is not None:
        fields.set_string(fields.root, "google_place_id", google_place_id.value())
    if google_place_type is not None:
        fields.set_string(fields.root, "google_place_type", google_place_type.value())
    return InputMedia("venue", fields, api_kwargs)


def InputPaidMediaPhoto(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputPaidMedia:
    return InputPaidMedia("photo", media, fields, api_kwargs)


def InputPaidMediaPhoto(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputPaidMedia:
    return InputPaidMedia("photo", media, fields, api_kwargs)


def InputPaidMediaPhoto(media: PhotoSize, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputPaidMedia:
    return InputPaidMedia("photo", media.file_id, fields, api_kwargs)


def InputPaidMediaVideo(media: String, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputPaidMedia:
    return InputPaidMedia("video", media, fields, api_kwargs)


def InputPaidMediaVideo(media: InputFile, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputPaidMedia:
    return InputPaidMedia("video", media, fields, api_kwargs)


def InputPaidMediaVideo(media: Video, fields: Optional[JsonDocument] = None, api_kwargs: Optional[JsonDocument] = None) raises -> InputPaidMedia:
    return InputPaidMedia("video", media.file_id, fields, api_kwargs)


def InputPaidMediaLivePhoto(
    media: String,
    photo: String,
    fields: Optional[JsonDocument] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputPaidMedia:
    var result = InputPaidMedia("live_photo", media, fields, api_kwargs)
    return result.with_file_field("photo", parse_file_input(photo, attach=True, local_mode=False))


def InputPaidMediaLivePhoto(
    media: Video,
    photo: PhotoSize,
    fields: Optional[JsonDocument] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputPaidMedia:
    var result = InputPaidMedia("live_photo", media.file_id, fields, api_kwargs)
    return result.with_file_field("photo", parse_file_input(photo.file_id, attach=True, local_mode=False))


def InputPaidMediaLivePhoto(
    media: InputFile,
    photo: InputFile,
    fields: Optional[JsonDocument] = None,
    api_kwargs: Optional[JsonDocument] = None,
) raises -> InputPaidMedia:
    var result = InputPaidMedia("live_photo", media, fields, api_kwargs)
    return result.with_file_field("photo", parse_file_input(photo, attach=True, local_mode=False))
