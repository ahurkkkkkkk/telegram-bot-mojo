from std.testing import assert_equal

from telegram import WebAppInfo
from telegram._utils.json import parse_json


def main() raises:
    var web_app = WebAppInfo.de_json(
        parse_json("{\"url\":\"https://example.test/app\",\"future\":7}")
    )
    assert_equal(web_app.url, "https://example.test/app")
    assert_equal(web_app == WebAppInfo("https://example.test/app"), True)
    assert_equal(hash(web_app), hash(WebAppInfo("https://example.test/app")))
    assert_equal(
        web_app.to_json(),
        "{\"url\": \"https://example.test/app\", \"future\": 7}",
    )
