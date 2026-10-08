from std.collections import List
from std.testing import assert_equal

from telegram import (
    PassportElementError,
    PassportElementErrorDataField,
    PassportElementErrorFile,
    PassportElementErrorFiles,
    PassportElementErrorFrontSide,
    PassportElementErrorReverseSide,
    PassportElementErrorSelfie,
    PassportElementErrorTranslationFile,
    PassportElementErrorTranslationFiles,
    PassportElementErrorUnspecified,
)
from telegram._utils.json import parse_json


def main() raises:
    var errors = List[PassportElementError]()
    errors.append(PassportElementError("custom", "passport", "base message"))
    errors.append(PassportElementErrorDataField("personal_details", "first_name", "data-hash", "bad name"))
    errors.append(PassportElementErrorFile("utility_bill", "file-hash", "bad file"))
    var hashes = List[String]()
    hashes.append("file-hash-a")
    hashes.append("file-hash-b")
    errors.append(PassportElementErrorFiles("bank_statement", hashes, "bad files"))
    errors.append(PassportElementErrorFrontSide("passport", "front-hash", "bad front"))
    errors.append(PassportElementErrorReverseSide("identity_card", "reverse-hash", "bad reverse"))
    errors.append(PassportElementErrorSelfie("driver_license", "selfie-hash", "bad selfie"))
    errors.append(PassportElementErrorTranslationFile("passport", "translation-hash", "bad translation"))
    errors.append(PassportElementErrorTranslationFiles("passport", hashes.copy(), "bad translations"))
    errors.append(PassportElementErrorUnspecified("address", "element-hash", "unspecified"))

    for error in errors:
        var encoded = error.to_json()
        var restored = PassportElementError.de_json(parse_json(encoded))
        assert_equal(restored == error, True)
        assert_equal(hash(restored), hash(error))

    var data_error = errors[1].copy()
    assert_equal(data_error.source, "data")
    assert_equal(data_error.field_name, "first_name")
    assert_equal(data_error.data_hash, "data-hash")
    var files_error = errors[3].copy()
    assert_equal(len(files_error.file_hashes), 2)
    assert_equal(files_error.file_hashes[1], "file-hash-b")
    var translated = errors[8].copy()
    assert_equal(translated.source, "translation_files")
    var empty_files = PassportElementErrorFiles(
        "bank_statement", List[String](), "no files"
    )
    var empty_files_json = empty_files.to_dict()
    assert_equal(empty_files_json.object_get(empty_files_json.root, "file_hashes"), -1)

    var future = PassportElementError.de_json(
        parse_json(
            '{"source":"file","type":"utility_bill","file_hash":"h",'
            '"message":"bad","future_field":true}'
        )
    )
    assert_equal(future.api_kwargs.object_get(future.api_kwargs.root, "future_field") != -1, True)
    var restored_future = PassportElementError.de_json(parse_json(future.to_json()))
    assert_equal(restored_future.api_kwargs.object_get(restored_future.api_kwargs.root, "future_field") != -1, True)

    var parsed_list = PassportElementError.de_list(
        parse_json("[" + errors[1].to_json() + "," + errors[2].to_json() + "]"), 0
    )
    assert_equal(len(parsed_list), 2)
