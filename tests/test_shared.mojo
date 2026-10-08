from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import ChatShared, SharedUser, UsersShared
from telegram._utils.json import parse_json


def main() raises:
    var shared_user = SharedUser.de_json(parse_json(
        '{"user_id":17,"first_name":"Ada","last_name":"Lovelace",'
        '"username":"ada","photo":[{"file_id":"p","file_unique_id":"u",'
        '"width":20,"height":30}],"future":true}'
    ))
    assert_equal(shared_user.name().value(), "@ada")
    assert_equal(shared_user.full_name().value(), "Ada Lovelace")
    assert_equal(shared_user.link().value(), "https://t.me/ada")
    assert_equal(shared_user.photo.value()[0].file_unique_id, "u")
    assert_equal(shared_user.api_kwargs.object_get(shared_user.api_kwargs.root, "future") != -1, True)
    var same_user_id = SharedUser(17, Optional[String]("Different"))
    assert_equal(shared_user == same_user_id, True)
    assert_equal(hash(shared_user), hash(same_user_id))
    var decoded_user = SharedUser.de_json(parse_json(shared_user.to_json()))
    assert_equal(decoded_user == shared_user, True)
    assert_equal(decoded_user.photo.value()[0].width, 20)

    var chat = ChatShared.de_json(parse_json(
        '{"request_id":6,"chat_id":1125899906842624,"title":"Room",'
        '"username":"room","photo":[{"file_id":"cp","file_unique_id":"cu",'
        '"width":40,"height":50}],"future_field":3}'
    ))
    assert_equal(chat.chat_id, 1125899906842624)
    assert_equal(chat.link().value(), "https://t.me/room")
    assert_equal(chat.photo.value()[0].height, 50)
    assert_equal(chat.api_kwargs.object_get(chat.api_kwargs.root, "future_field") != -1, True)
    var chat_round_trip = ChatShared.de_json(parse_json(chat.to_json()))
    assert_equal(chat_round_trip == chat, True)
    assert_equal(hash(chat_round_trip), hash(chat))

    var users = List[SharedUser]()
    users.append(shared_user.copy())
    var users_shared = UsersShared.de_json(parse_json(
        '{"request_id":9,"users":[{"user_id":17,"first_name":"Other"}],'
        '"user_ids":[17],"future":false}'
    ))
    assert_equal(users_shared.request_id, 9)
    assert_equal(users_shared.users[0].user_id, 17)
    assert_equal(users_shared.api_kwargs.object_get(users_shared.api_kwargs.root, "user_ids") != -1, True)
    assert_equal(users_shared.api_kwargs.object_get(users_shared.api_kwargs.root, "future") != -1, True)
    var same_users = UsersShared(9, users)
    assert_equal(users_shared == same_users, True)
    assert_equal(hash(users_shared), hash(same_users))
    var users_round_trip = UsersShared.de_json(parse_json(users_shared.to_json()))
    assert_equal(users_round_trip == users_shared, True)
    assert_equal(len(UsersShared.de_list(parse_json(
        '[{"request_id":1,"users":[]}]'
    ), 0)), 1)
    with assert_raises():
        _ = ChatShared.de_json(parse_json('{"request_id":1}'))
