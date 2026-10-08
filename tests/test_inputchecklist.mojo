from std.collections import List
from std.collections.optional import Optional
from std.testing import assert_equal

from telegram import InputChecklist, InputChecklistTask, MessageEntity
from telegram._utils.defaultvalue import DEFAULT_NONE
from telegram._utils.json import parse_json


def main() raises:
    var default_task = InputChecklistTask(7, "Review the report")
    assert_equal(default_task.parse_mode is None, True)
    assert_equal(default_task.parse_mode_is_default, True)
    assert_equal(default_task.to_json(), '{"id": 7, "text": "Review the report"}')

    var explicit_default_task = InputChecklistTask(8, "Send the draft", DEFAULT_NONE)
    assert_equal(explicit_default_task.parse_mode_is_default, True)
    var entity_list = List[MessageEntity]()
    entity_list.append(MessageEntity("bold", 0, 4))
    var explicit_task = InputChecklistTask(
        9,
        "Send the draft",
        Optional[String]("HTML"),
        Optional[List[MessageEntity]](entity_list.copy()),
    )
    assert_equal(explicit_task.parse_mode.value(), "HTML")
    assert_equal(explicit_task.parse_mode_is_default, False)
    assert_equal(explicit_task.text_entities[0].type, "bold")

    var tasks = List[InputChecklistTask]()
    tasks.append(default_task.copy())
    tasks.append(explicit_task.copy())
    var checklist = InputChecklist(
        "Release checklist",
        tasks,
        Optional[String]("MarkdownV2"),
        Optional[List[MessageEntity]](entity_list.copy()),
        Optional[Bool](True),
        Optional[Bool](False),
    )
    assert_equal(checklist.parse_mode_is_default, False)
    var json = checklist.to_json()
    var parsed = parse_json(json)
    var serialized_tasks = parsed.object_get(parsed.root, "tasks")
    assert_equal(serialized_tasks != -1, True)
    assert_equal(parsed.string_value(parsed.object_get(parsed.root, "parse_mode")), "MarkdownV2")
    assert_equal(checklist.to_dict().object_get(checklist.to_dict().root, "title_entities") != -1, True)
    var decoded_checklist = InputChecklist.de_json(parsed.copy())
    assert_equal(decoded_checklist == checklist, True)
    assert_equal(decoded_checklist.tasks[0].parse_mode_is_default, True)
    assert_equal(decoded_checklist.tasks[1].parse_mode.value(), "HTML")
    assert_equal(len(InputChecklist.de_list(parse_json("[" + json + "]"), 0)), 1)
    assert_equal(
        len(InputChecklistTask.de_list(parse_json("[" + explicit_task.to_json() + "]"), 0)),
        1,
    )

    var same_ids = List[InputChecklistTask]()
    same_ids.append(InputChecklistTask(7, "Different text"))
    same_ids.append(InputChecklistTask(9, "Different text"))
    var same_identity = InputChecklist("Different title", same_ids)
    assert_equal(checklist == same_identity, True)
    assert_equal(hash(checklist), hash(same_identity))
    assert_equal(default_task == InputChecklistTask(7, "Other text"), True)

    var default_checklist = InputChecklist("Checklist", tasks)
    assert_equal(default_checklist.parse_mode_is_default, True)
    assert_equal(default_checklist.to_dict().object_get(default_checklist.to_dict().root, "parse_mode"), -1)
    var with_future = InputChecklist.de_json(
        parse_json('{"title":"Future","tasks":[],"future_field":true}')
    )
    assert_equal(with_future.api_kwargs.object_get(with_future.api_kwargs.root, "future_field") != -1, True)
