from std.testing import assert_equal

from telegram import PTBDeprecationWarning, PTBRuntimeWarning, PTBUserWarning


def main() raises:
    var user_warning = PTBUserWarning("hello")
    assert_equal(user_warning.__str__(), "hello")

    var runtime_warning = PTBRuntimeWarning("runtime")
    assert_equal(runtime_warning.__str__(), "runtime")

    var deprecation = PTBDeprecationWarning("22.0", "use the new name")
    assert_equal(
        deprecation.__str__(),
        "Deprecated since version 22.0: use the new name",
    )
