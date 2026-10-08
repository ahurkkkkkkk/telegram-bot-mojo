from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import MessageEntity, Poll, PollOption
from telegram._utils.datetime import TimeDelta, TimestampDateTime
from telegram._utils.json import parse_json


def main() raises:
    var option_entities = List[MessageEntity]()
    option_entities.append(MessageEntity("bold", 3, 6))
    var options = List[PollOption]()
    options.append(
        PollOption(
            "A🚀Answer",
            3,
            option_entities,
            persistent_id=Optional[String]("yes-id"),
        )
    )
    var question_entities = List[MessageEntity]()
    question_entities.append(MessageEntity("bold", 3, 8))
    var explanation_entities = List[MessageEntity]()
    explanation_entities.append(MessageEntity("italic", 8, 6))
    var description_entities = List[MessageEntity]()
    description_entities.append(MessageEntity("underline", 5, 11))
    var correct = List[Int]()
    correct.append(0)
    var countries = List[String]()
    countries.append("US")
    var poll = Poll(
        "poll-id",
        "Q🚀Question",
        options,
        3,
        False,
        True,
        Poll.REGULAR,
        False,
        explanation=Optional[String]("Wrong 🚀answer"),
        explanation_entities=explanation_entities,
        open_period=Optional[TimeDelta](TimeDelta(300)),
        close_date=Optional[TimestampDateTime](TimestampDateTime(2026, 10, 1, 12, 30)),
        question_entities=question_entities,
        allows_revoting=Optional[Bool](True),
        members_only=Optional[Bool](False),
        correct_option_ids=correct,
        description=Optional[String]("Some description"),
        description_entities=description_entities,
        country_codes=countries,
    )
    assert_equal(poll.parse_question_entity(question_entities[0]), "Question")
    assert_equal(poll.parse_explanation_entity(explanation_entities[0]), "answer")
    assert_equal(poll.parse_description_entity(description_entities[0]), "description")
    assert_equal(len(poll.parse_question_entities()), 1)
    var encoded = poll.to_json()
    var decoded = Poll.de_json(parse_json(encoded))
    assert_equal(decoded == poll, True)
    assert_equal(decoded.options[0].persistent_id, "yes-id")
    assert_equal(decoded.open_period.value().total_seconds(), 300.0)
    assert_equal(decoded.close_date.value().year, 2026)
    assert_equal(decoded.correct_option_ids[0], 0)
    assert_equal(decoded.allows_revoting, True)
    assert_equal(decoded.members_only, False)
    assert_equal(len(Poll.de_list(parse_json("[" + encoded + "]"), 0)), 1)

    var future = Poll.de_json(
        parse_json('{"id":"p2","question":"Q","options":[],"total_voter_count":0,"is_closed":false,"is_anonymous":true,"type":"future_type","allows_multiple_answers":false,"allows_revoting":false,"members_only":true,"future":9}')
    )
    assert_equal(future.to_json(), '{"id": "p2", "question": "Q", "options": [], "total_voter_count": 0, "is_closed": false, "is_anonymous": true, "type": "future_type", "allows_multiple_answers": false, "allows_revoting": false, "members_only": true, "future": 9}')
    assert_equal(future.type, "future_type")
    with assert_raises():
        _ = Poll.de_json(parse_json('{"id":"missing-required"}'))
