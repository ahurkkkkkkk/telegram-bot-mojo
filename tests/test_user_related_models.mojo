from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import (
    ChatOwnerChanged,
    ChatOwnerLeft,
    DirectMessagesTopic,
    ProximityAlertTriggered,
    User,
)
from telegram._utils.json import parse_json


def main() raises:
    var traveler = User(1, "Traveler", False)
    var watcher = User(2, "Watcher", False)
    var alert = ProximityAlertTriggered(traveler.copy(), watcher.copy(), 25)
    assert_equal(
        alert.to_json(),
        "{\"traveler\": {\"id\": 1, \"first_name\": \"Traveler\", \"is_bot\": false}, \"watcher\": {\"id\": 2, \"first_name\": \"Watcher\", \"is_bot\": false}, \"distance\": 25}",
    )
    var decoded_alert = ProximityAlertTriggered.de_json(
        parse_json("{\"traveler\":{\"id\":1,\"first_name\":\"T\",\"is_bot\":false},\"watcher\":{\"id\":2,\"first_name\":\"W\",\"is_bot\":false},\"distance\":9,\"future\":true}")
    )
    assert_equal(decoded_alert.distance, 9)
    assert_equal(decoded_alert.traveler.id, 1)
    assert_equal(
        decoded_alert.to_json(),
        "{\"traveler\": {\"id\": 1, \"first_name\": \"T\", \"is_bot\": false}, \"watcher\": {\"id\": 2, \"first_name\": \"W\", \"is_bot\": false}, \"distance\": 9, \"future\": true}",
    )
    assert_equal(decoded_alert == ProximityAlertTriggered(User(1, "x", True), User(2, "y", True), 9), True)
    assert_equal(len(ProximityAlertTriggered.de_list(parse_json("[{\"traveler\":{\"id\":1,\"first_name\":\"T\",\"is_bot\":false},\"watcher\":{\"id\":2,\"first_name\":\"W\",\"is_bot\":false},\"distance\":1}]"), 0)), 1)

    var topic = DirectMessagesTopic(123, Optional[User](traveler.copy()))
    assert_equal(topic.to_json(), "{\"topic_id\": 123, \"user\": {\"id\": 1, \"first_name\": \"Traveler\", \"is_bot\": false}}")
    var decoded_topic = DirectMessagesTopic.de_json(
        parse_json("{\"topic_id\":123,\"user\":{\"id\":1,\"first_name\":\"T\",\"is_bot\":false}}")
    )
    assert_equal(decoded_topic.user.value().id, 1)
    assert_equal(decoded_topic == DirectMessagesTopic(123, Optional[User](User(1, "other", True))), True)
    assert_equal(len(DirectMessagesTopic.de_list(parse_json("[{\"topic_id\":4}]"), 0)), 1)

    var owner_changed = ChatOwnerChanged(traveler.copy())
    assert_equal(owner_changed.to_json(), "{\"new_owner\": {\"id\": 1, \"first_name\": \"Traveler\", \"is_bot\": false}}")
    var decoded_owner = ChatOwnerChanged.de_json(
        parse_json("{\"new_owner\":{\"id\":1,\"first_name\":\"T\",\"is_bot\":false}}")
    )
    assert_equal(decoded_owner.new_owner.id, 1)
    assert_equal(decoded_owner == ChatOwnerChanged(User(1, "x", True)), True)

    var owner_left = ChatOwnerLeft(Optional[User](traveler.copy()))
    assert_equal(owner_left.to_json(), "{\"new_owner\": {\"id\": 1, \"first_name\": \"Traveler\", \"is_bot\": false}}")
    var decoded_left = ChatOwnerLeft.de_json(parse_json("{\"new_owner\":null}"))
    assert_equal(decoded_left.new_owner is None, True)
    assert_equal(decoded_left == ChatOwnerLeft(), True)
    assert_equal(len(ChatOwnerLeft.de_list(parse_json("[{}]"), 0)), 1)
    with assert_raises():
        _ = ChatOwnerChanged.de_json(parse_json("{}"))
