from std.testing import assert_equal, assert_raises

from telegram.request import HTTPXRequest


def main() raises:
    var request = HTTPXRequest(
        connection_pool_size=8,
        read_timeout=2.5,
        write_timeout=3.0,
        connect_timeout=1.0,
        pool_timeout=0.25,
        http_version="1.1",
        media_write_timeout=12.0,
    )
    assert_equal(request.connection_pool_size, 8)
    assert_equal(request.read_timeout.value(), 2.5)
    assert_equal(request.write_timeout.value(), 3.0)
    assert_equal(request.connect_timeout.value(), 1.0)
    assert_equal(request.pool_timeout.value(), 0.25)
    assert_equal(request.media_write_timeout.value(), 12.0)
    assert_equal(request.http_version, "1.1")

    var supports_http2 = HTTPXRequest(http_version="2")
    assert_equal(supports_http2.http_version, "2")

    with assert_raises():
        _ = HTTPXRequest(connection_pool_size=0)
    with assert_raises():
        _ = HTTPXRequest(http_version="3")
    with assert_raises():
        _ = request.do_request("not a valid URL", "GET")

    request.shutdown()
    assert_equal(request.is_closed, True)
    with assert_raises():
        _ = request.do_request("not a valid URL", "GET")
    request.initialize()
    assert_equal(request.is_closed, False)
