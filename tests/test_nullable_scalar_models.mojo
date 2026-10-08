from std.testing import assert_equal

from telegram import (
    BusinessBotRights,
    ChatAdministratorRights,
    ChatPermissions,
    DirectMessagePriceChanged,
    ForumTopic,
    ForumTopicCreated,
    ForumTopicEdited,
    KeyboardButtonRequestManagedBot,
    KeyboardButtonRequestUsers,
    LocationAddress,
    LoginUrl,
    RefundedPayment,
    StarAmount,
    SwitchInlineQueryChosenChat,
    UserRating,
    WriteAccessAllowed,
)
from telegram._utils.json import parse_json


def main() raises:
    var business = BusinessBotRights(can_reply=True, can_manage_stories=False)
    var business_round_trip = BusinessBotRights.de_json(parse_json(business.to_json()))
    assert_equal(business_round_trip == business, True)
    assert_equal(hash(business_round_trip), hash(business))
    assert_equal(business_round_trip.can_reply.value(), True)
    assert_equal(business_round_trip.can_read_messages is None, True)

    var permissions = ChatPermissions()
    assert_equal(permissions.to_json(), "{}")
    var all_permissions = ChatPermissions.all_permissions()
    assert_equal(all_permissions.can_send_messages.value(), True)
    assert_equal(all_permissions.can_react_to_messages.value(), True)
    var permissions_round_trip = ChatPermissions.de_json(parse_json(all_permissions.to_json()))
    assert_equal(permissions_round_trip == all_permissions, True)
    var no_permissions = ChatPermissions.no_permissions()
    assert_equal(no_permissions.can_send_messages.value(), False)

    var rights = ChatAdministratorRights.all_rights()
    assert_equal(rights.is_anonymous, True)
    assert_equal(rights.can_manage_tags.value(), True)
    var rights_round_trip = ChatAdministratorRights.de_json(parse_json(rights.to_json()))
    assert_equal(rights_round_trip == rights, True)
    var no_rights = ChatAdministratorRights.no_rights()
    assert_equal(no_rights.is_anonymous, False)
    assert_equal(no_rights.can_manage_tags.value(), False)

    var price_change = DirectMessagePriceChanged(True, 4)
    var price_round_trip = DirectMessagePriceChanged.de_json(parse_json(price_change.to_json()))
    assert_equal(price_round_trip == price_change, True)
    assert_equal(hash(price_round_trip), hash(price_change))
    assert_equal(price_round_trip.direct_message_star_count.value(), 4)

    var topic = ForumTopic(23, "News", 0x6FB9F0, "icon-id", True)
    var same_identity = ForumTopic(23, "News", 0x6FB9F0, "other-icon", False)
    assert_equal(topic == same_identity, True)
    assert_equal(hash(topic), hash(same_identity))
    var topic_round_trip = ForumTopic.de_json(parse_json(topic.to_json()))
    assert_equal(topic_round_trip == topic, True)
    assert_equal(topic_round_trip.icon_custom_emoji_id.value(), "icon-id")

    var created = ForumTopicCreated("News", 4)
    var created_round_trip = ForumTopicCreated.de_json(parse_json(created.to_json()))
    assert_equal(created_round_trip == created, True)
    assert_equal(created_round_trip.icon_custom_emoji_id is None, True)

    var edited = ForumTopicEdited()
    var edited_round_trip = ForumTopicEdited.de_json(parse_json(edited.to_json()))
    assert_equal(edited_round_trip == edited, True)
    assert_equal(edited_round_trip.name is None, True)

    var users_request = KeyboardButtonRequestUsers(9, user_is_bot=True, max_quantity=4)
    var users_request_round_trip = KeyboardButtonRequestUsers.de_json(
        parse_json(users_request.to_json())
    )
    assert_equal(users_request_round_trip == users_request, True)
    assert_equal(users_request_round_trip.user_is_bot.value(), True)
    assert_equal(users_request_round_trip.user_is_premium is None, True)

    var managed_request = KeyboardButtonRequestManagedBot(12, "Helper", "helper_bot")
    var managed_round_trip = KeyboardButtonRequestManagedBot.de_json(
        parse_json(managed_request.to_json())
    )
    assert_equal(managed_round_trip == managed_request, True)
    assert_equal(managed_round_trip.suggested_username.value(), "helper_bot")

    var login_url = LoginUrl("https://example.test/login", "Continue", "helper_bot", True)
    var login_round_trip = LoginUrl.de_json(parse_json(login_url.to_json()))
    assert_equal(login_round_trip == login_url, True)
    assert_equal(login_round_trip.request_write_access.value(), True)

    var sparse_login = LoginUrl("https://example.test/login")
    assert_equal(sparse_login.to_json(), "{\"url\": \"https://example.test/login\"}")

    var refund = RefundedPayment("XTR", 20, "invoice", "charge", "provider")
    var refund_round_trip = RefundedPayment.de_json(parse_json(refund.to_json()))
    assert_equal(refund_round_trip == refund, True)
    assert_equal(hash(refund_round_trip), hash(refund))
    assert_equal(refund_round_trip.provider_payment_charge_id.value(), "provider")

    var stars = StarAmount(15, 2)
    var stars_round_trip = StarAmount.de_json(parse_json(stars.to_json()))
    assert_equal(stars_round_trip == stars, True)
    assert_equal(stars_round_trip.nanostar_amount.value(), 2)

    var address = LocationAddress("US", "CA", "San Francisco", "Market St")
    var address_round_trip = LocationAddress.de_json(parse_json(address.to_json()))
    assert_equal(address_round_trip == address, True)
    assert_equal(address_round_trip.city.value(), "San Francisco")

    var switch_query = SwitchInlineQueryChosenChat("find", True, False, True, False)
    var switch_round_trip = SwitchInlineQueryChosenChat.de_json(
        parse_json(switch_query.to_json())
    )
    assert_equal(switch_round_trip == switch_query, True)
    assert_equal(switch_round_trip.allow_group_chats.value(), True)

    var rating = UserRating(2, 30, 5, 45)
    var rating_round_trip = UserRating.de_json(parse_json(rating.to_json()))
    assert_equal(rating_round_trip == rating, True)
    assert_equal(rating_round_trip.next_level_rating.value(), 45)

    var access = WriteAccessAllowed("mini_app", True, False)
    var access_round_trip = WriteAccessAllowed.de_json(parse_json(access.to_json()))
    assert_equal(access_round_trip == access, True)
    assert_equal(access_round_trip.from_attachment_menu.value(), False)
