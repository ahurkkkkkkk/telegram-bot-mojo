#!/usr/bin/env mojo
#
# Native checklist models corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""Checklist and checklist-task values."""

from std.collections import Dict, List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._messageentity import MessageEntity
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.entities import parse_message_entities, parse_message_entity
from telegram._utils.json import JSON_ARRAY, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _checklist_require_object(data: JsonDocument, class_name: String) raises:
    if data.root < 0 or data.root >= len(data.nodes):
        raise Error(String(class_name, " JSON document has no root"))
    if data.nodes[data.root].kind != JSON_OBJECT:
        raise Error(String(class_name, " JSON value is not an object"))


def _checklist_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    if index < 0 or index >= len(data.nodes):
        raise Error("Checklist JSON node index is out of range")
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _checklist_api_kwargs(data: JsonDocument, fields: List[String]) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var is_model_field = False
        for field in fields:
            if key == field:
                is_model_field = True
                break
        if not is_model_field:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _checklist_entities_array(
    mut result: JsonDocument, key: String, entities: List[MessageEntity]
) raises:
    if len(entities) == 0:
        return
    var array_index = result.add_array()
    for entity in entities:
        var entity_document = entity.to_dict()
        var entity_index = result.copy_subtree_from(entity_document, entity_document.root)
        result.append_child(array_index, entity_index)
    result.object_set(result.root, key, array_index)


def _checklist_parse_entities(
    text: String,
    entities: List[MessageEntity],
    types: Optional[List[String]],
) raises -> Dict[MessageEntity, String]:
    return parse_message_entities(text, entities, types)


struct ChecklistTask(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A task identified by its stable checklist-local ID."""

    var id: Int
    var text: String
    var text_entities: List[MessageEntity]
    var completed_by_user: Optional[User]
    var completed_by_chat: Optional[Chat]
    var completion_date: Optional[TimestampDateTime]
    var api_kwargs: JsonDocument

    def __init__(out self, id: Int, text: String):
        self.id = id
        self.text = text.copy()
        self.text_entities = List[MessageEntity]()
        self.completed_by_user = None
        self.completed_by_chat = None
        self.completion_date = None
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: Int,
        text: String,
        text_entities: List[MessageEntity],
        completed_by_user: Optional[User] = None,
        completion_date: Optional[TimestampDateTime] = None,
        completed_by_chat: Optional[Chat] = None,
    ):
        self.id = id
        self.text = text.copy()
        self.text_entities = text_entities.copy()
        self.completed_by_user = completed_by_user.copy()
        self.completed_by_chat = completed_by_chat.copy()
        self.completion_date = completion_date.copy()
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        id: Int,
        text: String,
        text_entities: List[MessageEntity],
        completed_by_user: Optional[User],
        completion_date: Optional[TimestampDateTime],
        completed_by_chat: Optional[Chat],
        *,
        api_kwargs: JsonDocument,
    ):
        self.id = id
        self.text = text.copy()
        self.text_entities = text_entities.copy()
        self.completed_by_user = completed_by_user.copy()
        self.completed_by_chat = completed_by_chat.copy()
        self.completion_date = completion_date.copy()
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.id = existing.id
        self.text = existing.text.copy()
        self.text_entities = existing.text_entities.copy()
        self.completed_by_user = existing.completed_by_user.copy()
        self.completed_by_chat = existing.completed_by_chat.copy()
        self.completion_date = existing.completion_date.copy()
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return self.id == other.id

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("ChecklistTask\0").as_bytes())
        hasher.update(String(self.id).as_bytes())

    def parse_entity(self, entity: MessageEntity) raises -> String:
        return parse_message_entity(self.text, entity)

    def parse_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        return _checklist_parse_entities(self.text, self.text_entities, types)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_number(result.root, "id", String(self.id))
        result.set_string(result.root, "text", self.text)
        _checklist_entities_array(result, "text_entities", self.text_entities)
        if self.completed_by_user is not None:
            var user_document = self.completed_by_user.value().to_dict(recursive=recursive)
            var user_node = result.copy_subtree_from(user_document, user_document.root)
            result.object_set(result.root, "completed_by_user", user_node)
        if self.completed_by_chat is not None:
            var chat_document = self.completed_by_chat.value().to_dict(recursive=recursive)
            var chat_node = result.copy_subtree_from(chat_document, chat_document.root)
            result.object_set(result.root, "completed_by_chat", chat_node)
        if self.completion_date is not None:
            result.set_number(
                result.root,
                "completion_date",
                String(to_timestamp(self.completion_date.value())),
            )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _checklist_require_object(data, "ChecklistTask")
        var id_index = data.object_get(data.root, "id")
        var text_index = data.object_get(data.root, "text")
        if id_index == -1 or text_index == -1:
            raise Error("ChecklistTask JSON object is missing id or text")
        var entities = List[MessageEntity]()
        var entities_index = data.object_get(data.root, "text_entities")
        if entities_index != -1 and not data.is_null(entities_index):
            if data.nodes[entities_index].kind != JSON_ARRAY:
                raise Error("ChecklistTask text_entities must be an array")
            var entity_documents = data.array_documents(entities_index)
            for item in entity_documents:
                entities.append(MessageEntity.de_json(item))
        var completed_by_user: Optional[User] = None
        var user_index = data.object_get(data.root, "completed_by_user")
        if user_index != -1 and not data.is_null(user_index):
            completed_by_user = Optional[User](
                User.de_json(_checklist_nested(data, user_index)).copy()
            )
        var completed_by_chat: Optional[Chat] = None
        var chat_index = data.object_get(data.root, "completed_by_chat")
        if chat_index != -1 and not data.is_null(chat_index):
            completed_by_chat = Optional[Chat](
                Chat.de_json(_checklist_nested(data, chat_index)).copy()
            )
        var completion_date: Optional[TimestampDateTime] = None
        var date_index = data.object_get(data.root, "completion_date")
        if date_index != -1 and not data.is_null(date_index):
            completion_date = Optional[TimestampDateTime](
                from_timestamp(data.integer_value(date_index))
            )
        var fields = List[String]()
        fields.append("id")
        fields.append("text")
        fields.append("text_entities")
        fields.append("completed_by_user")
        fields.append("completed_by_chat")
        fields.append("completion_date")
        var api_kwargs = _checklist_api_kwargs(data, fields)
        return ChecklistTask(
            data.integer_value(id_index),
            data.string_value(text_index),
            entities,
            completed_by_user,
            completion_date,
            completed_by_chat,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^


struct Checklist(Equatable, Hashable, Copyable, TelegramJsonObject):
    """A list of tasks with a title and optional editing permissions."""

    var title: String
    var title_entities: List[MessageEntity]
    var tasks: List[ChecklistTask]
    var others_can_add_tasks: Optional[Bool]
    var others_can_mark_tasks_as_done: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(out self, title: String, tasks: List[ChecklistTask]):
        self.title = title.copy()
        self.title_entities = List[MessageEntity]()
        self.tasks = tasks.copy()
        self.others_can_add_tasks = None
        self.others_can_mark_tasks_as_done = None
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        tasks: List[ChecklistTask],
        title_entities: List[MessageEntity],
        others_can_add_tasks: Optional[Bool] = None,
        others_can_mark_tasks_as_done: Optional[Bool] = None,
    ):
        self.title = title.copy()
        self.title_entities = title_entities.copy()
        self.tasks = tasks.copy()
        self.others_can_add_tasks = others_can_add_tasks
        self.others_can_mark_tasks_as_done = others_can_mark_tasks_as_done
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        title: String,
        tasks: List[ChecklistTask],
        title_entities: List[MessageEntity],
        others_can_add_tasks: Optional[Bool],
        others_can_mark_tasks_as_done: Optional[Bool],
        *,
        api_kwargs: JsonDocument,
    ):
        self.title = title.copy()
        self.title_entities = title_entities.copy()
        self.tasks = tasks.copy()
        self.others_can_add_tasks = others_can_add_tasks
        self.others_can_mark_tasks_as_done = others_can_mark_tasks_as_done
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.title = existing.title.copy()
        self.title_entities = existing.title_entities.copy()
        self.tasks = existing.tasks.copy()
        self.others_can_add_tasks = existing.others_can_add_tasks
        self.others_can_mark_tasks_as_done = existing.others_can_mark_tasks_as_done
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        if len(self.tasks) != len(other.tasks):
            return False
        for index in range(len(self.tasks)):
            if self.tasks[index] != other.tasks[index]:
                return False
        return True

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String("Checklist\0").as_bytes())
        for task in self.tasks:
            hasher.update(String(hash(task)).as_bytes())
            hasher.update(String("\0").as_bytes())

    def parse_entity(self, entity: MessageEntity) raises -> String:
        return parse_message_entity(self.title, entity)

    def parse_entities(
        self, types: Optional[List[String]] = None
    ) raises -> Dict[MessageEntity, String]:
        return _checklist_parse_entities(self.title, self.title_entities, types)

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        result.set_string(result.root, "title", self.title)
        _checklist_entities_array(result, "title_entities", self.title_entities)
        var tasks_array = result.add_array()
        for task in self.tasks:
            var task_document = task.to_dict(recursive=recursive)
            var task_node = result.copy_subtree_from(task_document, task_document.root)
            result.append_child(tasks_array, task_node)
        result.object_set(result.root, "tasks", tasks_array)
        if self.others_can_add_tasks is not None:
            result.set_boolean(result.root, "others_can_add_tasks", self.others_can_add_tasks.value())
        if self.others_can_mark_tasks_as_done is not None:
            result.set_boolean(
                result.root,
                "others_can_mark_tasks_as_done",
                self.others_can_mark_tasks_as_done.value(),
            )
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        _checklist_require_object(data, "Checklist")
        var title_index = data.object_get(data.root, "title")
        var tasks_index = data.object_get(data.root, "tasks")
        if title_index == -1 or tasks_index == -1:
            raise Error("Checklist JSON object is missing title or tasks")
        if data.nodes[tasks_index].kind != JSON_ARRAY:
            raise Error("Checklist tasks must be an array")
        var title_entities = List[MessageEntity]()
        var title_entities_index = data.object_get(data.root, "title_entities")
        if title_entities_index != -1 and not data.is_null(title_entities_index):
            if data.nodes[title_entities_index].kind != JSON_ARRAY:
                raise Error("Checklist title_entities must be an array")
            var title_entity_documents = data.array_documents(title_entities_index)
            for item in title_entity_documents:
                title_entities.append(MessageEntity.de_json(item))
        var tasks = ChecklistTask.de_list(data, tasks_index)
        var others_can_add_tasks: Optional[Bool] = None
        var add_index = data.object_get(data.root, "others_can_add_tasks")
        if add_index != -1 and not data.is_null(add_index):
            others_can_add_tasks = Optional[Bool](data.boolean_value(add_index))
        var others_can_mark_tasks_as_done: Optional[Bool] = None
        var mark_index = data.object_get(data.root, "others_can_mark_tasks_as_done")
        if mark_index != -1 and not data.is_null(mark_index):
            others_can_mark_tasks_as_done = Optional[Bool](data.boolean_value(mark_index))
        var fields = List[String]()
        fields.append("title")
        fields.append("title_entities")
        fields.append("tasks")
        fields.append("others_can_add_tasks")
        fields.append("others_can_mark_tasks_as_done")
        var api_kwargs = _checklist_api_kwargs(data, fields)
        return Checklist(
            data.string_value(title_index),
            tasks,
            title_entities,
            others_can_add_tasks,
            others_can_mark_tasks_as_done,
            api_kwargs=api_kwargs,
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for index in range(len(items)):
            result.append(Self.de_json(items[index].copy()))
        return result^
