from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import ChatMember, User
from telegram._utils.datetime import TimestampDateTime, to_timestamp
from telegram._utils.json import parse_json


def main() raises:
    var unknown = ChatMember.de_json(
        parse_json(
            '{"status":"future_status","user":{"id":1,"first_name":"Ada",'
            '"is_bot":false},"future_permission":{"value":true}}'
        )
    )
    assert_equal(unknown.status, "future_status")
    assert_equal(unknown.user.id, 1)
    assert_equal(unknown.has_field("future_permission"), False)
    assert_equal(unknown.api_kwargs.object_get(unknown.api_kwargs.root, "future_permission") != -1, True)
    assert_equal(unknown.to_dict().object_get(unknown.to_dict().root, "status") != -1, True)

    var admin = ChatMember.de_json(
        parse_json(
            '{"status":"administrator","user":{"id":2,"first_name":"Grace",'
            '"is_bot":false},"can_be_edited":true,"is_anonymous":false,'
            '"can_manage_chat":true,"can_delete_messages":true,'
            '"can_manage_video_chats":false,"can_restrict_members":true,'
            '"can_promote_members":false,"can_change_info":true,'
            '"can_invite_users":true,"can_post_stories":true,'
            '"can_edit_stories":false,"can_delete_stories":true,'
            '"can_post_messages":null,"custom_title":"Admin", "future": 9}'
        )
    )
    assert_equal(admin.status, ChatMember.ADMINISTRATOR)
    assert_equal(admin.optional_boolean_field("can_manage_chat").value(), True)
    assert_equal(admin.optional_string_field("custom_title").value(), "Admin")
    assert_equal(admin.optional_boolean_field("can_post_messages") is None, True)
    assert_equal(admin.api_kwargs.object_get(admin.api_kwargs.root, "future") != -1, True)
    assert_equal(admin.field_json("can_delete_stories").boolean_value(0), True)

    var member = ChatMember.de_json(
        parse_json(
            '{"status":"member","user":{"id":3,"first_name":"Lin",'
            '"is_bot":false},"until_date":1790951700,"tag":"helper"}'
        )
    )
    assert_equal(member.optional_string_field("tag").value(), "helper")
    assert_equal(to_timestamp(member.until_date_value().value()), 1790951700)
    var date = TimestampDateTime(2026, 10, 2, 9, 15, 0)
    assert_equal(ChatMember.de_json(parse_json(member.to_json())) == member, True)
    assert_equal(len(ChatMember.de_list(parse_json("[" + member.to_json() + "]"), 0)), 1)

    var base = ChatMember(User(1, "Ada", False), "unknown")
    assert_equal(base.to_dict().object_get(base.to_dict().root, "status") != -1, True)
    var constructor_user = User(10, "Owner", False)
    var owner = ChatMember.owner(constructor_user.copy(), True, Optional[String]("Founder"))
    assert_equal(owner.status, ChatMember.OWNER)
    assert_equal(owner.optional_boolean_field("is_anonymous").value(), True)
    assert_equal(owner.optional_string_field("custom_title").value(), "Founder")
    var administrator = ChatMember.administrator(
        constructor_user.copy(), True, False, True, True, False, True, False,
        True, True, True, False, True, Optional[Bool](False),
    )
    assert_equal(administrator.status, ChatMember.ADMINISTRATOR)
    assert_equal(administrator.optional_boolean_field("can_post_messages").value(), False)
    var member_constructor = ChatMember.member(
        constructor_user.copy(), Optional[TimestampDateTime](date.copy()),
        Optional[String]("member-tag"),
    )
    assert_equal(member_constructor.optional_string_field("tag").value(), "member-tag")
    var restricted = ChatMember.restricted(
        constructor_user.copy(), True, False, True, False, True, False, True, False,
        True, date.copy(), True, False, True, False, True, False, True, False,
        Optional[String]("restricted-tag"),
    )
    assert_equal(restricted.optional_boolean_field("can_react_to_messages").value(), False)
    assert_equal(ChatMember.left(constructor_user.copy()).status, ChatMember.LEFT)
    assert_equal(ChatMember.banned(constructor_user.copy(), date.copy()).status, ChatMember.BANNED)
    with assert_raises():
        _ = ChatMember.de_json(parse_json('{"status":"administrator","user":{"id":1}}'))
    with assert_raises():
        _ = ChatMember.de_json(parse_json("{}"))
