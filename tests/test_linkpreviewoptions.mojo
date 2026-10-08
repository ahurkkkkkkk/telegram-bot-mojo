from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import LinkPreviewOptions
from telegram._utils.argumentparsing import parse_lpo_and_dwpp
from telegram._utils.json import parse_json


def main() raises:
    var configured = LinkPreviewOptions(True, "https://example.test", True, False, True)
    assert_equal(
        configured.to_json(),
        "{\"is_disabled\": true, \"prefer_large_media\": false, \"prefer_small_media\": true, \"show_above_text\": true, \"url\": \"https://example.test\"}",
    )
    var decoded = LinkPreviewOptions.de_json(parse_json(configured.to_json()))
    assert_equal(decoded == configured, True)
    assert_equal(hash(decoded), hash(configured))
    assert_equal(decoded.url.value(), "https://example.test")

    var sparse = LinkPreviewOptions()
    assert_equal(sparse.to_json(), "{}")

    var future = LinkPreviewOptions.de_json(
        parse_json("{\"url\":\"https://example.test\",\"future_flag\":true}")
    )
    assert_equal(
        future.to_json(),
        "{\"url\": \"https://example.test\", \"future_flag\": true}",
    )

    var resolved = parse_lpo_and_dwpp(Optional[Bool](False), None)
    assert_equal(resolved.value().is_disabled.value(), False)
    var resolved_over_existing = parse_lpo_and_dwpp(
        Optional[Bool](False), Optional[LinkPreviewOptions](configured.copy())
    )
    assert_equal(resolved_over_existing.value().is_disabled.value(), False)
    assert_equal(resolved_over_existing.value().url is None, True)
    var unchanged = parse_lpo_and_dwpp(None, Optional[LinkPreviewOptions](configured.copy()))
    assert_equal(unchanged.value() == configured, True)

    var rejected = False
    try:
        _ = parse_lpo_and_dwpp(
            Optional[Bool](True), Optional[LinkPreviewOptions](configured.copy())
        )
    except error:
        rejected = True
    assert_equal(rejected, True)
