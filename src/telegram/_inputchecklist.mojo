#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8 _inputchecklist.py.
# LGPL-3.0-or-later; see LICENSE.

"""Checklist values used when creating checklists through the Bot API."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._messageentity import MessageEntity
from telegram._utils.defaultvalue import DefaultValue
from telegram._utils.json import JSON_ARRAY, JSON_BOOL, JSON_OBJECT, JSON_STRING, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _input_checklist_api_kwargs(data: JsonDocument, known_fields: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var known = False
        for field in known_fields:
            if field == key:
                known = True
                break
        if not known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


struct InputChecklistTask(Equatable, Hashable, Copyable):
    """A checklist task to send to Telegram; equality uses its unique task ID."""

    var id: Int
    var text: String
    var parse_mode: Optional[String]
    var parse_mode_is_default: Bool
    var text_entities: List[MessageEntity]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        id: Int,
        text: String,
        parse_mode: Optional[String] = None,
        text_entities: Optional[List[MessageEntity]] = None,
        *,
        parse_mode_is_default: Bool = True,
    ):
        self.id = id
        self.text = text.copy()
        self.parse_mode = parse_mode.copy()
        self.parse_mode_is_default = parse_mode_is_default and parse_mode is None
        self.text_entities = _input_checklist_entities(text_entities)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: Int,
        text: String,
        parse_mode: String,
        text_entities: Optional[List[MessageEntity]] = None,
    ):
        self.id = id
        self.text = text.copy()
        self.parse_mode = Optional[String](parse_mode.copy())
        self.parse_mode_is_default = False
        self.text_entities = _input_checklist_entities(text_entities)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: Int,
        text: String,
        parse_mode: DefaultValue[String],
        text_entities: Optional[List[MessageEntity]] = None,
    ):
        self.id = id
        self.text = text.copy()
        self.parse_mode = Optional[String](parse_mode.value.copy())
        self.parse_mode_is_default = parse_mode.is_sentinel
        self.text_entities = _input_checklist_entities(text_entities)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: Int,
        text: String,
        parse_mode: DefaultValue[NoneType],
        text_entities: Optional[List[MessageEntity]] = None,
    ):
        self.id = id
        self.text = text.copy()
        self.parse_mode = None
        self.parse_mode_is_default = parse_mode.is_sentinel
        self.text_entities = _input_checklist_entities(text_entities)
        self.api_kwargs = empty_json_object()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id
        self.text = existing.text.copy()
        self.parse_mode = existing.parse_mode.copy()
        self.parse_mode_is_default = existing.parse_mode_is_default
        self.text_entities = existing.text_entities.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "id", String(self.id))
        if self.parse_mode is not None:
            result.set_string(result.root, "parse_mode", self.parse_mode.value())
        result.set_string(result.root, "text", self.text)
        if len(self.text_entities) > 0:
            var entities = result.add_array()
            result.object_set(result.root, "text_entities", entities)
            for entity in self.text_entities:
                var data = entity.to_dict(recursive)
                var child = result.copy_subtree_from(data, data.root)
                result.append_child(entities, child)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InputChecklistTask JSON value must be an object")
        var id_index = data.object_get(data.root, "id")
        var text_index = data.object_get(data.root, "text")
        if id_index == -1 or text_index == -1:
            raise Error("InputChecklistTask JSON object is missing id or text")
        if data.nodes[text_index].kind != JSON_STRING:
            raise Error("InputChecklistTask text must be a string")
        var parse_mode_index = data.object_get(data.root, "parse_mode")
        var parse_mode: Optional[String] = None
        if parse_mode_index != -1 and not data.is_null(parse_mode_index):
            if data.nodes[parse_mode_index].kind != JSON_STRING:
                raise Error("InputChecklistTask parse_mode must be a string or null")
            parse_mode = Optional[String](data.string_value(parse_mode_index))
        var text_entities = List[MessageEntity]()
        var entities_index = data.object_get(data.root, "text_entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("InputChecklistTask text_entities must be an array")
            text_entities = MessageEntity.de_list(data, entities_index)
        var result = Self(
            data.integer_value(id_index), data.string_value(text_index), parse_mode,
            Optional[List[MessageEntity]](text_entities.copy()),
            parse_mode_is_default=parse_mode_index == -1,
        )
        var known_fields = List[String]()
        known_fields.append("id")
        known_fields.append("parse_mode")
        known_fields.append("text")
        known_fields.append("text_entities")
        result.api_kwargs = _input_checklist_api_kwargs(data, known_fields)
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^


def _input_checklist_entities(
    entities: Optional[List[MessageEntity]],
) -> List[MessageEntity]:
    if entities is None:
        return List[MessageEntity]()
    return entities.value().copy()


struct InputChecklist(Equatable, Hashable, Copyable):
    """A checklist request value; equality and hashing use the task sequence."""

    var others_can_add_tasks: Optional[Bool]
    var others_can_mark_tasks_as_done: Optional[Bool]
    var parse_mode: Optional[String]
    var parse_mode_is_default: Bool
    var tasks: List[InputChecklistTask]
    var title: String
    var title_entities: List[MessageEntity]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        title: String,
        tasks: List[InputChecklistTask],
        parse_mode: Optional[String] = None,
        title_entities: Optional[List[MessageEntity]] = None,
        others_can_add_tasks: Optional[Bool] = None,
        others_can_mark_tasks_as_done: Optional[Bool] = None,
        *,
        parse_mode_is_default: Bool = True,
    ):
        self.others_can_add_tasks = others_can_add_tasks
        self.others_can_mark_tasks_as_done = others_can_mark_tasks_as_done
        self.parse_mode = parse_mode.copy()
        self.parse_mode_is_default = parse_mode_is_default and parse_mode is None
        self.tasks = tasks.copy()
        self.title = title.copy()
        self.title_entities = _input_checklist_entities(title_entities)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        tasks: List[InputChecklistTask],
        parse_mode: String,
        title_entities: Optional[List[MessageEntity]] = None,
        others_can_add_tasks: Optional[Bool] = None,
        others_can_mark_tasks_as_done: Optional[Bool] = None,
    ):
        self.others_can_add_tasks = others_can_add_tasks
        self.others_can_mark_tasks_as_done = others_can_mark_tasks_as_done
        self.parse_mode = Optional[String](parse_mode.copy())
        self.parse_mode_is_default = False
        self.tasks = tasks.copy()
        self.title = title.copy()
        self.title_entities = _input_checklist_entities(title_entities)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        tasks: List[InputChecklistTask],
        parse_mode: DefaultValue[String],
        title_entities: Optional[List[MessageEntity]] = None,
        others_can_add_tasks: Optional[Bool] = None,
        others_can_mark_tasks_as_done: Optional[Bool] = None,
    ):
        self.others_can_add_tasks = others_can_add_tasks
        self.others_can_mark_tasks_as_done = others_can_mark_tasks_as_done
        self.parse_mode = Optional[String](parse_mode.value.copy())
        self.parse_mode_is_default = parse_mode.is_sentinel
        self.tasks = tasks.copy()
        self.title = title.copy()
        self.title_entities = _input_checklist_entities(title_entities)
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        tasks: List[InputChecklistTask],
        parse_mode: DefaultValue[NoneType],
        title_entities: Optional[List[MessageEntity]] = None,
        others_can_add_tasks: Optional[Bool] = None,
        others_can_mark_tasks_as_done: Optional[Bool] = None,
    ):
        self.others_can_add_tasks = others_can_add_tasks
        self.others_can_mark_tasks_as_done = others_can_mark_tasks_as_done
        self.parse_mode = None
        self.parse_mode_is_default = parse_mode.is_sentinel
        self.tasks = tasks.copy()
        self.title = title.copy()
        self.title_entities = _input_checklist_entities(title_entities)
        self.api_kwargs = empty_json_object()

    def __copyinit__(out self, existing: Self):
        self.others_can_add_tasks = existing.others_can_add_tasks
        self.others_can_mark_tasks_as_done = existing.others_can_mark_tasks_as_done
        self.parse_mode = existing.parse_mode.copy()
        self.parse_mode_is_default = existing.parse_mode_is_default
        self.tasks = existing.tasks.copy()
        self.title = existing.title.copy()
        self.title_entities = existing.title_entities.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.tasks == other.tasks

    def __hash__[H: Hasher](self, mut hasher: H):
        for task in self.tasks:
            hasher.update(String("\0").as_bytes())
            hasher.update(String(task.id).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        if self.others_can_add_tasks is not None:
            result.set_boolean(
                result.root, "others_can_add_tasks", self.others_can_add_tasks.value()
            )
        if self.others_can_mark_tasks_as_done is not None:
            result.set_boolean(
                result.root, "others_can_mark_tasks_as_done",
                self.others_can_mark_tasks_as_done.value(),
            )
        if self.parse_mode is not None:
            result.set_string(result.root, "parse_mode", self.parse_mode.value())
        if len(self.tasks) > 0:
            var task_array = result.add_array()
            result.object_set(result.root, "tasks", task_array)
            for task in self.tasks:
                var data = task.to_dict(recursive)
                var child = result.copy_subtree_from(data, data.root)
                result.append_child(task_array, child)
        result.set_string(result.root, "title", self.title)
        if len(self.title_entities) > 0:
            var entities = result.add_array()
            result.object_set(result.root, "title_entities", entities)
            for entity in self.title_entities:
                var data = entity.to_dict(recursive)
                var child = result.copy_subtree_from(data, data.root)
                result.append_child(entities, child)
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("InputChecklist JSON value must be an object")
        var title_index = data.object_get(data.root, "title")
        var tasks_index = data.object_get(data.root, "tasks")
        if title_index == -1 or tasks_index == -1:
            raise Error("InputChecklist JSON object is missing title or tasks")
        if data.nodes[title_index].kind != JSON_STRING:
            raise Error("InputChecklist title must be a string")
        if data.nodes[tasks_index].kind != JSON_ARRAY:
            raise Error("InputChecklist tasks must be an array")
        var task_documents = data.array_documents(tasks_index)
        var tasks = List[InputChecklistTask]()
        for task_document in task_documents:
            tasks.append(InputChecklistTask.de_json(task_document))
        var parse_mode_index = data.object_get(data.root, "parse_mode")
        var parse_mode: Optional[String] = None
        if parse_mode_index != -1 and not data.is_null(parse_mode_index):
            if data.nodes[parse_mode_index].kind != JSON_STRING:
                raise Error("InputChecklist parse_mode must be a string or null")
            parse_mode = Optional[String](data.string_value(parse_mode_index))
        var title_entities = List[MessageEntity]()
        var title_entities_index = data.object_get(data.root, "title_entities")
        if title_entities_index != -1 and not data.is_null(title_entities_index):
            if data.nodes[title_entities_index].kind != JSON_ARRAY:
                raise Error("InputChecklist title_entities must be an array")
            title_entities = MessageEntity.de_list(data, title_entities_index)
        var others_can_add_tasks: Optional[Bool] = None
        var add_index = data.object_get(data.root, "others_can_add_tasks")
        if add_index != -1 and not data.is_null(add_index):
            if data.nodes[add_index].kind != JSON_BOOL:
                raise Error("InputChecklist others_can_add_tasks must be Boolean or null")
            others_can_add_tasks = Optional[Bool](data.boolean_value(add_index))
        var others_can_mark_tasks_as_done: Optional[Bool] = None
        var mark_index = data.object_get(data.root, "others_can_mark_tasks_as_done")
        if mark_index != -1 and not data.is_null(mark_index):
            if data.nodes[mark_index].kind != JSON_BOOL:
                raise Error("InputChecklist others_can_mark_tasks_as_done must be Boolean or null")
            others_can_mark_tasks_as_done = Optional[Bool](data.boolean_value(mark_index))
        var result = Self(
            data.string_value(title_index), tasks, parse_mode,
            Optional[List[MessageEntity]](title_entities.copy()),
            others_can_add_tasks, others_can_mark_tasks_as_done,
            parse_mode_is_default=parse_mode_index == -1,
        )
        var known_fields = List[String]()
        known_fields.append("others_can_add_tasks")
        known_fields.append("others_can_mark_tasks_as_done")
        known_fields.append("parse_mode")
        known_fields.append("tasks")
        known_fields.append("title")
        known_fields.append("title_entities")
        result.api_kwargs = _input_checklist_api_kwargs(data, known_fields)
        return result^

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^
