#!/usr/bin/env mojo
#
# Native cryptographic primitives used by the Telegram Passport port.
# LGPL-3.0-or-later; see LICENSE.

"""Telegram Passport decoding implemented with native Mojo and system OpenSSL."""

from std.collections import List
from std.collections.optional import Optional
from std.ffi import OwnedDLHandle
from std.memory import Pointer

from telegram.error import PassportDecryptionError
from telegram._utils.json import JsonDocument, parse_json


def base64_decode(value: String) raises -> List[UInt8]:
    """Decode canonical RFC 4648 base64, rejecting invalid alphabet and padding."""
    var input = value.as_bytes()
    if len(input) == 0:
        return List[UInt8]()
    if len(input) % 4 != 0:
        raise PassportDecryptionError("Invalid base64 padding")

    var output = List[UInt8]()
    var accumulator = UInt32(0)
    var bit_count = 0
    var padding_started = False
    var padding_count = 0
    var data_characters = 0
    for index in range(len(input)):
        var byte = input[index]
        var sextet: Int
        if byte >= 65 and byte <= 90:
            sextet = Int(byte) - 65
        elif byte >= 97 and byte <= 122:
            sextet = Int(byte) - 97 + 26
        elif byte >= 48 and byte <= 57:
            sextet = Int(byte) - 48 + 52
        elif byte == 43:
            sextet = 62
        elif byte == 47:
            sextet = 63
        elif byte == 61:
            padding_started = True
            padding_count += 1
            continue
        else:
            raise PassportDecryptionError("Invalid base64 character")

        if padding_started:
            raise PassportDecryptionError("Invalid base64 padding")
        data_characters += 1
        accumulator = (accumulator << 6) | UInt32(sextet)
        bit_count += 6
        if bit_count >= 8:
            bit_count -= 8
            output.append(UInt8((accumulator >> UInt32(bit_count)) & 0xFF))
            accumulator &= (UInt32(1) << UInt32(bit_count)) - 1

    if padding_count > 2:
        raise PassportDecryptionError("Invalid base64 padding")
    if padding_count == 1 and data_characters % 4 != 3:
        raise PassportDecryptionError("Invalid base64 padding")
    if padding_count == 2 and data_characters % 4 != 2:
        raise PassportDecryptionError("Invalid base64 padding")
    if padding_count == 0 and data_characters % 4 != 0:
        raise PassportDecryptionError("Invalid base64 padding")
    if bit_count != 0 and accumulator != 0:
        raise PassportDecryptionError("Non-zero trailing bits in base64 value")
    return output^


def _valid_utf8(value: List[UInt8]) -> Bool:
    var index = 0
    while index < len(value):
        var first = value[index]
        if first <= 0x7F:
            index += 1
            continue

        var width: Int
        if first >= 0xC2 and first <= 0xDF:
            width = 2
        elif first >= 0xE0 and first <= 0xEF:
            width = 3
        elif first >= 0xF0 and first <= 0xF4:
            width = 4
        else:
            return False
        if index + width > len(value):
            return False
        var second = value[index + 1]
        if second < 0x80 or second > 0xBF:
            return False
        if first == 0xE0 and second < 0xA0:
            return False
        if first == 0xED and second > 0x9F:
            return False
        if first == 0xF0 and second < 0x90:
            return False
        if first == 0xF4 and second > 0x8F:
            return False
        for offset in range(2, width):
            var continuation = value[index + offset]
            if continuation < 0x80 or continuation > 0xBF:
                return False
        index += width
    return True


def decrypt_passport_data(
    secret: List[UInt8], expected_hash: List[UInt8], ciphertext: List[UInt8]
) raises -> List[UInt8]:
    """Derive Telegram's AES-256 key/IV, decrypt CBC, verify SHA-256, strip prefix."""
    if len(expected_hash) != 32:
        raise PassportDecryptionError("Passport data hash must contain 32 bytes")
    if len(ciphertext) == 0 or len(ciphertext) % 16 != 0:
        raise PassportDecryptionError("Passport ciphertext must be a non-empty AES block sequence")
    if len(secret) + len(expected_hash) > 2147483647 or len(ciphertext) > 2147483647:
        raise PassportDecryptionError("Passport payload is too large")

    var crypto = OwnedDLHandle("libcrypto.so.3")
    var sha512 = crypto.get_function[UInt]("SHA512")
    var sha256 = crypto.get_function[UInt]("SHA256")
    var ctx_new = crypto.get_function[UInt]("EVP_CIPHER_CTX_new")
    var ctx_free = crypto.get_function[NoneType]("EVP_CIPHER_CTX_free")
    var aes_256_cbc = crypto.get_function[UInt]("EVP_aes_256_cbc")
    var decrypt_init = crypto.get_function[Int32]("EVP_DecryptInit_ex")
    var set_padding = crypto.get_function[Int32]("EVP_CIPHER_CTX_set_padding")
    var decrypt_update = crypto.get_function[Int32]("EVP_DecryptUpdate")
    var decrypt_final = crypto.get_function[Int32]("EVP_DecryptFinal_ex")
    var memcmp = crypto.get_function[Int32]("CRYPTO_memcmp")
    var cleanse = crypto.get_function[NoneType]("OPENSSL_cleanse")

    var material = List[UInt8]()
    for byte in secret:
        material.append(byte)
    for byte in expected_hash:
        material.append(byte)
    var derived = List[UInt8]()
    for _ in range(64):
        derived.append(0)
    if sha512(material.unsafe_ptr(), UInt(material.__len__()), derived.unsafe_ptr()) == 0:
        raise PassportDecryptionError("OpenSSL SHA-512 key derivation failed")

    var key = List[UInt8]()
    var iv = List[UInt8]()
    for index in range(32):
        key.append(derived[index])
    for index in range(32, 48):
        iv.append(derived[index])

    var ctx = ctx_new()
    if ctx == 0:
        raise PassportDecryptionError("OpenSSL could not allocate an AES context")
    var init_status = decrypt_init(ctx, aes_256_cbc(), 0, key.unsafe_ptr(), iv.unsafe_ptr())
    if init_status != 1:
        ctx_free(ctx)
        raise PassportDecryptionError("OpenSSL AES initialization failed")
    if set_padding(ctx, 0) != 1:
        ctx_free(ctx)
        raise PassportDecryptionError("OpenSSL could not disable PKCS padding")

    var clear = List[UInt8]()
    for _ in range(len(ciphertext) + 16):
        clear.append(0)
    var update_length = Int32(0)
    var update_status = decrypt_update(
        ctx,
        clear.unsafe_ptr(),
        Pointer(to=update_length),
        ciphertext.unsafe_ptr(),
        Int32(len(ciphertext)),
    )
    if update_status != 1:
        ctx_free(ctx)
        raise PassportDecryptionError("OpenSSL AES-CBC decryption failed")

    var final_bytes = List[UInt8]()
    for _ in range(16):
        final_bytes.append(0)
    var final_length = Int32(0)
    var final_status = decrypt_final(
        ctx,
        final_bytes.unsafe_ptr(),
        Pointer(to=final_length),
    )
    ctx_free(ctx)
    if final_status != 1:
        raise PassportDecryptionError("OpenSSL AES-CBC finalization failed")
    for index in range(Int(final_length)):
        clear[Int(update_length) + index] = final_bytes[index]
    var clear_length = Int(update_length) + Int(final_length)
    if clear_length > len(clear):
        cleanse(key.unsafe_ptr(), UInt(len(key)))
        cleanse(iv.unsafe_ptr(), UInt(len(iv)))
        cleanse(derived.unsafe_ptr(), UInt(len(derived)))
        cleanse(material.unsafe_ptr(), UInt(len(material)))
        cleanse(clear.unsafe_ptr(), UInt(len(clear)))
        raise PassportDecryptionError("OpenSSL returned an invalid AES plaintext length")

    var actual_hash = List[UInt8]()
    for _ in range(32):
        actual_hash.append(0)
    if sha256(clear.unsafe_ptr(), UInt(clear_length), actual_hash.unsafe_ptr()) == 0:
        raise PassportDecryptionError("OpenSSL SHA-256 verification failed")
    if memcmp(actual_hash.unsafe_ptr(), expected_hash.unsafe_ptr(), UInt(32)) != 0:
        cleanse(key.unsafe_ptr(), UInt(len(key)))
        cleanse(iv.unsafe_ptr(), UInt(len(iv)))
        cleanse(derived.unsafe_ptr(), UInt(len(derived)))
        cleanse(material.unsafe_ptr(), UInt(len(material)))
        cleanse(clear.unsafe_ptr(), UInt(len(clear)))
        raise PassportDecryptionError("Hashes are not equal")
    if clear_length == 0:
        raise PassportDecryptionError("Decrypted Passport payload is empty")
    var prefix_length = Int(clear[0])
    var result = List[UInt8]()
    var start = prefix_length
    if start > clear_length:
        start = clear_length
    for index in range(start, clear_length):
        result.append(clear[index])
    cleanse(key.unsafe_ptr(), UInt(len(key)))
    cleanse(iv.unsafe_ptr(), UInt(len(iv)))
    cleanse(derived.unsafe_ptr(), UInt(len(derived)))
    cleanse(material.unsafe_ptr(), UInt(len(material)))
    cleanse(clear.unsafe_ptr(), UInt(len(clear)))
    return result^


def decrypt_passport_json(
    secret: List[UInt8], expected_hash: List[UInt8], ciphertext: List[UInt8]
) raises -> JsonDocument:
    var clear = decrypt_passport_data(secret, expected_hash, ciphertext)
    if not _valid_utf8(clear):
        raise PassportDecryptionError("Decrypted Passport data is not valid UTF-8")
    var json_text = String(from_utf8_lossy=clear)
    try:
        return parse_json(json_text)
    except:
        raise PassportDecryptionError("Decrypted Passport data is not valid JSON")


def rsa_oaep_sha1_decrypt(
    private_key_pem: String,
    ciphertext: List[UInt8],
    password: Optional[String] = None,
) raises -> List[UInt8]:
    """Decrypt Telegram's RSA-OAEP/SHA-1 secret using a PEM private key."""
    if private_key_pem.byte_length() == 0 or len(ciphertext) == 0:
        raise PassportDecryptionError("Private key and ciphertext must not be empty")
    if private_key_pem.byte_length() > 2147483647 or len(ciphertext) > 2147483647:
        raise PassportDecryptionError("Passport RSA payload is too large")

    var crypto = OwnedDLHandle("libcrypto.so.3")
    var bio_new = crypto.get_function[UInt]("BIO_new_mem_buf")
    var bio_free = crypto.get_function[Int32]("BIO_free")
    var read_private_key = crypto.get_function[UInt]("PEM_read_bio_PrivateKey")
    var pkey_free = crypto.get_function[NoneType]("EVP_PKEY_free")
    var get_rsa = crypto.get_function[UInt]("EVP_PKEY_get1_RSA")
    var rsa_free = crypto.get_function[NoneType]("RSA_free")
    var rsa_size = crypto.get_function[Int32]("RSA_size")
    var rsa_private_decrypt = crypto.get_function[Int32]("RSA_private_decrypt")
    var cleanse = crypto.get_function[NoneType]("OPENSSL_cleanse")

    var pem = private_key_pem.copy()
    var bio = bio_new(pem.unsafe_ptr(), Int32(pem.byte_length()))
    if bio == 0:
        raise PassportDecryptionError("OpenSSL could not read the PEM private key")
    var pkey: UInt
    if password is None:
        pkey = read_private_key(bio, 0, 0, UInt(0))
    else:
        var password_text = password.value().copy()
        var password_c_string = password_text.as_c_string_span()
        pkey = read_private_key(bio, 0, 0, password_c_string.ptr())
    _ = bio_free(bio)
    if pkey == 0:
        raise PassportDecryptionError("OpenSSL could not load the PEM private key")
    var rsa = get_rsa(pkey)
    if rsa == 0:
        pkey_free(pkey)
        raise PassportDecryptionError("Passport private key is not an RSA key")
    var modulus_size = rsa_size(rsa)
    if modulus_size <= 0 or len(ciphertext) != Int(modulus_size):
        rsa_free(rsa)
        pkey_free(pkey)
        raise PassportDecryptionError("RSA ciphertext length does not match the private key")

    var output = List[UInt8]()
    for _ in range(modulus_size):
        output.append(0)
    # RSA_PKCS1_OAEP_PADDING is 4. OpenSSL's default OAEP digest and MGF1 digest are SHA-1.
    var clear_length = rsa_private_decrypt(
        Int32(len(ciphertext)), ciphertext.unsafe_ptr(), output.unsafe_ptr(), rsa, 4
    )
    rsa_free(rsa)
    pkey_free(pkey)
    if clear_length < 0:
        cleanse(output.unsafe_ptr(), UInt(len(output)))
        raise PassportDecryptionError("RSA-OAEP private-key decryption failed")

    var result = List[UInt8]()
    for index in range(Int(clear_length)):
        result.append(output[index])
    cleanse(output.unsafe_ptr(), UInt(len(output)))
    return result^


def validate_rsa_private_key(
    private_key_pem: String, password: Optional[String] = None
) raises -> Bool:
    """Check that PEM input parses as an RSA private key without retaining it."""
    if private_key_pem.byte_length() == 0 or private_key_pem.byte_length() > 2147483647:
        return False
    var crypto = OwnedDLHandle("libcrypto.so.3")
    var bio_new = crypto.get_function[UInt]("BIO_new_mem_buf")
    var bio_free = crypto.get_function[Int32]("BIO_free")
    var read_private_key = crypto.get_function[UInt]("PEM_read_bio_PrivateKey")
    var pkey_free = crypto.get_function[NoneType]("EVP_PKEY_free")
    var get_rsa = crypto.get_function[UInt]("EVP_PKEY_get1_RSA")
    var rsa_free = crypto.get_function[NoneType]("RSA_free")

    var pem = private_key_pem.copy()
    var bio = bio_new(pem.unsafe_ptr(), Int32(pem.byte_length()))
    if bio == 0:
        return False
    var pkey: UInt
    if password is None:
        pkey = read_private_key(bio, 0, 0, UInt(0))
    else:
        var password_text = password.value().copy()
        var password_c_string = password_text.as_c_string_span()
        pkey = read_private_key(bio, 0, 0, password_c_string.ptr())
    _ = bio_free(bio)
    if pkey == 0:
        return False
    var rsa = get_rsa(pkey)
    if rsa != 0:
        rsa_free(rsa)
    pkey_free(pkey)
    return rsa != 0
