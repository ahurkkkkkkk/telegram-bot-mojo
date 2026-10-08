from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal, assert_raises

from telegram import Checklist, ChecklistTask, MessageEntity, User
from telegram._utils.datetime import TimestampDateTime
from telegram._utils.json import parse_json


def main() raises:
    var entities = List[MessageEntity]()
    entities.append(MessageEntity("bold", 3, 4))
    var completed_at = TimestampDateTime(2026, 10, 1, 12, 30)
    var task = ChecklistTask(
        5,
        "A🚀Task",
        entities,
        Optional[User](User(7, "Ada", False)),
        Optional[TimestampDateTime](completed_at.copy()),
    )
    assert_equal(task.parse_entity(entities[0]), "Task")
    assert_equal(len(task.parse_entities()), 1)
    var task_json = task.to_json()
    var decoded_task = ChecklistTask.de_json(parse_json(task_json))
    assert_equal(decoded_task == task, True)
    assert_equal(decoded_task.completion_date.value().year, 2026)
    assert_equal(decoded_task.completed_by_user.value().id, 7)
    assert_equal(len(ChecklistTask.de_list(parse_json("[" + task_json + "]"), 0)), 1)

    var tasks = List[ChecklistTask]()
    tasks.append(task.copy())
    var checklist = Checklist("Daily", tasks, List[MessageEntity](), Optional[Bool](True))
    var checklist_json = checklist.to_json()
    var decoded_checklist = Checklist.de_json(parse_json(checklist_json))
    assert_equal(decoded_checklist == checklist, True)
    assert_equal(decoded_checklist.title, "Daily")
    assert_equal(decoded_checklist.others_can_add_tasks.value(), True)
    assert_equal(decoded_checklist.tasks[0].id, 5)
    assert_equal(len(Checklist.de_list(parse_json("[" + checklist_json + "]"), 0)), 1)
    assert_equal(checklist == Checklist("Another title", tasks), True)

    var future = Checklist.de_json(
        parse_json('{"title":"Future","tasks":[],"future_field":true}')
    )
    assert_equal(future.to_json(), '{"title": "Future", "tasks": [], "future_field": true}')
    with assert_raises():
        _ = Checklist.de_json(parse_json('{"title":"Missing tasks"}'))
