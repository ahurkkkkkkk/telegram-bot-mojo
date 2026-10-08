from std.testing import assert_equal, assert_raises
from std.collections.optional import Optional

from telegram import Chat, ChatIdentifier, InaccessibleMessage, MaybeInaccessibleMessage, Message
from telegram._utils.json import parse_json


def main() raises:
    var source = parse_json(
        '{"message_id":42,"date":1700000000,"chat":{"id":-1001,"type":"supergroup"},'
        '"from":{"id":7,"first_name":"Ada","is_bot":false},"text":"A😀B",'
        '"entities":[{"type":"bold","offset":1,"length":2},'
        '{"type":"italic","offset":0,"length":3}],'
        '"future_field":{"kept":true}}'
    )
    var message = Message.de_json(source)
    assert_equal(message.message_id, 42)
    assert_equal(message.chat.id, -1001)
    assert_equal(message.from_user.value().id, 7)
    assert_equal(message.text.value(), "A😀B")
    assert_equal(message.chat_id(), -1001)
    assert_equal(message.id(), 42)
    assert_equal(message.is_accessible(), True)
    assert_equal(message.parse_entity(message.entities[0]), "😀")
    assert_equal(message.parse_entities()[message.entities[0]], "😀")
    var quote_result = message.compute_quote_position_and_entities("😀")
    assert_equal(quote_result[0], 1)
    assert_equal(quote_result[1].value()[0].offset, 0)
    assert_equal(quote_result[1].value()[0].length, 2)
    assert_equal(quote_result[1].value()[1].offset, 0)
    assert_equal(quote_result[1].value()[1].length, 2)
    var reply_args = message.build_reply_arguments(
        quote=Optional[String]("😀"),
        allow_sending_without_reply=Optional[Bool](True),
    )
    assert_equal(reply_args.chat_id.number, -1001)
    assert_equal(reply_args.reply_parameters.message_id, 42)
    assert_equal(reply_args.reply_parameters.quote_position.value(), 1)
    assert_equal(reply_args.reply_parameters.quote_entities[0].length, 2)
    assert_equal(reply_args.reply_parameters.allow_sending_without_reply.value(), True)
    var cross_chat_reply = message.build_reply_arguments(
        target_chat_id=Optional[ChatIdentifier](ChatIdentifier(-2002)),
        allow_sending_without_reply=Optional[Bool](True),
    )
    assert_equal(cross_chat_reply.chat_id.number, -2002)
    assert_equal(cross_chat_reply.reply_parameters.chat_id_number, -1001)
    assert_equal(cross_chat_reply.reply_parameters.allow_sending_without_reply is None, True)
    assert_equal(message.api_kwargs.object_get(message.api_kwargs.root, "future_field") != -1, True)
    var with_attachments = Message.de_json(parse_json(
        '{"message_id":5,"date":1,"chat":{"id":1,"type":"private"},'
        '"audio":{"file_id":"a","file_unique_id":"au","duration":3},'
        '"animation":{"file_id":"b","file_unique_id":"bu","width":20,'
        '"height":10,"duration":4},'
        '"photo":[{"file_id":"p","file_unique_id":"pu","width":100,"height":50}],'
        '"new_chat_members":[{"id":9,"first_name":"Lin","is_bot":false}]}'
    ))
    assert_equal(with_attachments.audio.value().file_id, "a")
    assert_equal(with_attachments.animation.value().file_id, "b")
    assert_equal(with_attachments.photo[0].width, 100)
    assert_equal(with_attachments.new_chat_members[0].first_name, "Lin")
    assert_equal(with_attachments.effective_attachment().value().type, "animation")
    assert_equal(
        with_attachments.effective_attachment().value().payload.string_value(
            with_attachments.effective_attachment().value().payload.object_get(
                with_attachments.effective_attachment().value().payload.root, "file_id"
            )
        ),
        "b",
    )
    var media_round_trip = Message.de_json(parse_json(with_attachments.to_json()))
    assert_equal(media_round_trip.audio.value().duration.total_seconds(), 3.0)
    assert_equal(media_round_trip.photo[0].file_unique_id, "pu")
    assert_equal(media_round_trip.new_chat_members[0].id, 9)
    var no_attachment = Message.de_json(parse_json(
        '{"message_id":6,"date":1,"chat":{"id":1,"type":"private"},"photo":[]}'
    ))
    assert_equal(no_attachment.effective_attachment() is None, True)
    var metadata_message = Message.de_json(parse_json(
        '{"message_id":8,"date":1,"chat":{"id":-1001,"type":"supergroup"},'
        '"edit_date":2,"new_chat_title":"new title","delete_chat_photo":false,'
        '"migrate_to_chat_id":-2002,"media_group_id":"group-1",'
        '"is_topic_message":true,"message_thread_id":12,"has_protected_content":true,'
        '"sender_boost_count":3,"business_connection_id":"business-1",'
        '"is_paid_post":false,"reply_to_poll_option_id":"poll-option",'
        '"guest_query_id":"guest-1","future_flag":true}'
    ))
    assert_equal(metadata_message.edit_date.value().timestamp(), 2.0)
    assert_equal(metadata_message.delete_chat_photo.value(), False)
    assert_equal(metadata_message.migrate_to_chat_id.value(), -2002)
    assert_equal(metadata_message.media_group_id.value(), "group-1")
    assert_equal(metadata_message.message_thread_id.value(), 12)
    assert_equal(metadata_message.is_topic_message.value(), True)
    assert_equal(metadata_message.is_paid_post.value(), False)
    assert_equal(metadata_message.api_kwargs.object_get(metadata_message.api_kwargs.root, "future_flag") != -1, True)
    var metadata_round_trip = Message.de_json(parse_json(metadata_message.to_json()))
    assert_equal(metadata_round_trip.media_group_id.value(), "group-1")
    assert_equal(metadata_round_trip.delete_chat_photo.value(), False)
    assert_equal(metadata_round_trip.is_topic_message.value(), True)
    var repeated_quote = Message.de_json(parse_json(
        '{"message_id":7,"date":1,"chat":{"id":1,"type":"private"},'
        '"text":"x😀q x😀q"}'
    ))
    assert_equal(repeated_quote.compute_quote_position_and_entities("😀q", 1)[0], 6)
    with assert_raises():
        _ = repeated_quote.compute_quote_position_and_entities("missing")

    var encoded = message.to_dict()
    assert_equal(encoded.object_get(encoded.root, "from") != -1, True)
    assert_equal(encoded.object_get(encoded.root, "from_user"), -1)
    assert_equal(encoded.object_get(encoded.root, "future_field") != -1, True)
    var round_trip = Message.de_json(parse_json(message.to_json()))
    assert_equal(round_trip == message, True)
    assert_equal(hash(round_trip), hash(message))
    assert_equal(len(Message.de_list(parse_json(
        '[{"message_id":1,"date":0,"chat":{"id":1,"type":"private"}}]'
    ), 0)), 1)

    var same_identity = Message.de_json(parse_json(
        '{"message_id":42,"date":1,"chat":{"id":-1001,"type":"group"},"text":"different"}'
    ))
    assert_equal(same_identity == message, True)
    assert_equal(hash(same_identity), hash(message))
    assert_equal(same_identity.link(), None)
    var linked = Message.de_json(parse_json(
        '{"message_id":9,"date":2,"chat":{"id":-1001,"type":"supergroup",'
        '"username":"public_chat"},"is_topic_message":true,"message_thread_id":6}'
    ))
    assert_equal(linked.link().value(), "https://t.me/public_chat/9?thread=6")
    assert_equal(linked.parse_message_thread_id(ChatIdentifier(-1001)).value(), 6)
    assert_equal(linked.parse_message_thread_id(ChatIdentifier(-2002)) is None, True)
    assert_equal(
        linked.parse_message_thread_id(
            ChatIdentifier(-2002), Optional[Int](9)
        ).value(),
        9,
    )
    var direct_topic = Message.de_json(parse_json(
        '{"message_id":11,"date":1,"chat":{"id":2,"type":"private"},'
        '"direct_messages_topic":{"topic_id":44}}'
    ))
    assert_equal(direct_topic.direct_messages_topic.value().topic_id, 44)
    assert_equal(direct_topic.extract_direct_messages_topic_id().value(), 44)
    var service_message = Message.de_json(parse_json(
        '{"message_id":12,"date":1,"chat":{"id":2,"type":"private"},'
        '"web_app_data":{"data":"payload","button_text":"Open"},'
        '"video_chat_started":{},"video_chat_ended":{"duration":12},'
        '"chat_shared":{"request_id":5,"chat_id":-20}}'
    ))
    assert_equal(service_message.web_app_data.value().data, "payload")
    assert_equal(service_message.video_chat_started is not None, True)
    assert_equal(service_message.video_chat_ended.value().duration.total_seconds(), 12.0)
    assert_equal(service_message.chat_shared.value().chat_id, -20)
    assert_equal(service_message.api_kwargs.object_get(service_message.api_kwargs.root, "web_app_data"), -1)
    var service_round_trip = Message.de_json(parse_json(service_message.to_json()))
    assert_equal(service_round_trip.web_app_data.value().button_text, "Open")
    assert_equal(service_round_trip.video_chat_ended.value().duration.total_seconds(), 12.0)
    var inaccessible_date = Message.de_json(parse_json(
        '{"message_id":10,"date":0,"chat":{"id":1,"type":"private"}}'
    ))
    assert_equal(inaccessible_date.is_accessible(), False)
    var accessible_union = MaybeInaccessibleMessage(message)
    var inaccessible_value = InaccessibleMessage(Chat(-1001, "private"), 42)
    var inaccessible_union = MaybeInaccessibleMessage(inaccessible_value)
    assert_equal(accessible_union == inaccessible_union, True)
    assert_equal(hash(accessible_union), hash(inaccessible_union))
    assert_equal(inaccessible_union.is_accessible(), False)
    assert_equal(inaccessible_union.id(), 42)
    assert_equal(inaccessible_union.chat_id(), -1001)
    assert_equal(inaccessible_value.id(), 42)
    assert_equal(inaccessible_value.chat_id(), -1001)
    with assert_raises():
        _ = Message.de_json(parse_json('{"message_id":2,"date":0}'))
