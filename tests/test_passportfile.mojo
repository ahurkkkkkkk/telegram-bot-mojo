from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    Credentials,
    DataCredentials,
    FileCredentials,
    PassportFile,
    SecureData,
    SecureValue,
)
from telegram._utils.datetime import TimestampDateTime, to_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var file_date = TimestampDateTime(1970, 1, 1, 0, 0, 1)
    var credentials = FileCredentials("file-hash", "secret")
    var passport_file = PassportFile(
        "file-id", "unique-id", file_date, 4096,
        Optional[FileCredentials](credentials.copy())
    )
    var encoded = passport_file.to_json()
    var decoded = PassportFile.de_json(parse_json(encoded))
    assert_equal(decoded == passport_file, True)
    assert_equal(hash(decoded), hash(passport_file))
    assert_equal(decoded.file_id, "file-id")
    assert_equal(decoded.file_size, 4096)
    assert_equal(to_timestamp(decoded.file_date), 1)
    assert_equal(decoded.credentials is None, True)

    var same_identity = PassportFile(
        "different-file-id", "unique-id", TimestampDateTime(2026, 1, 1), 9
    )
    assert_equal(same_identity == passport_file, True)

    var future = PassportFile.de_json(
        parse_json(
            '{"file_id":"id","file_unique_id":"uid","file_date":123,'
            '"file_size":5,"future_field":{"safe":true}}'
        )
    )
    assert_equal(future.api_kwargs.object_get(future.api_kwargs.root, "future_field") != -1, True)
    var future_round_trip = PassportFile.de_json(parse_json(future.to_json()))
    assert_equal(
        future_round_trip.api_kwargs.object_get(
            future_round_trip.api_kwargs.root, "future_field"
        ) != -1,
        True,
    )

    var decrypted = PassportFile.de_json_decrypted(
        parse_json(
            '{"file_id":"id","file_unique_id":"uid","file_date":123,'
            '"file_size":5}'
        ),
        credentials,
    )
    assert_equal(decrypted.credentials is not None, True)
    assert_equal(decrypted.credentials.value().file_hash, "file-hash")

    var list_json = parse_json(
        '[{"file_id":"id","file_unique_id":"uid","file_date":123,"file_size":5}]'
    )
    var files = PassportFile.de_list(list_json, list_json.root)
    assert_equal(len(files), 1)
    var file_credentials = List[FileCredentials]()
    file_credentials.append(credentials.copy())
    var decrypted_files = PassportFile.de_list_decrypted(
        list_json, list_json.root, file_credentials
    )
    assert_equal(len(decrypted_files), 1)
    assert_equal(decrypted_files[0].credentials is not None, True)
    with assert_raises():
        _ = PassportFile.de_list_decrypted(list_json, list_json.root, List[FileCredentials]())
    with assert_raises():
        _ = PassportFile.de_json(parse_json('{"file_id":"id"}'))

    var credential_json = credentials.to_json()
    var decoded_credentials = FileCredentials.de_json(parse_json(credential_json))
    assert_equal(decoded_credentials == credentials, True)
    assert_equal(decoded_credentials.data_hash, "file-hash")
    assert_equal(len(FileCredentials.de_list(parse_json("[" + credential_json + "]"), 0)), 1)

    var data_credentials = DataCredentials("data-hash", "data-secret")
    var decoded_data_credentials = DataCredentials.de_json(
        parse_json(data_credentials.to_json())
    )
    assert_equal(decoded_data_credentials == data_credentials, True)
    assert_equal(decoded_data_credentials.data_hash, "data-hash")
    assert_equal(decoded_data_credentials.file_hash, "data-hash")

    var secure_value = SecureValue(data=Optional[DataCredentials](data_credentials.copy()))
    var secure_data = SecureData(
        personal_details=Optional[SecureValue](secure_value.copy())
    )
    var credentials_model = Credentials(Optional[SecureData](secure_data.copy()), "nonce-value")
    var credentials_round_trip = Credentials.de_json(
        parse_json(credentials_model.to_json())
    )
    assert_equal(credentials_round_trip.nonce, "nonce-value")
    assert_equal(credentials_round_trip.secure_data is not None, True)
    var restored_secure_value = credentials_round_trip.secure_data.value().personal_details.value().copy()
    assert_equal(restored_secure_value.data.value().data_hash, "data-hash")

    var future_credentials = Credentials.de_json(
        parse_json(
            '{"nonce":"n","secure_data":{"passport":{"selfie":'
            '{"hash":"h","secret":"s"},"future":"kept"},"future_secure":1},'
            '"future_credentials":true}'
        )
    )
    assert_equal(
        future_credentials.api_kwargs.object_get(
            future_credentials.api_kwargs.root, "future_credentials"
        ) != -1,
        True,
    )
    assert_equal(
        future_credentials.secure_data.value().api_kwargs.object_get(
            future_credentials.secure_data.value().api_kwargs.root, "future_secure"
        ) != -1,
        True,
    )
