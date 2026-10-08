#!/usr/bin/env mojo
#
# Native data-model translation of python-telegram-bot v22.8
# _chatmemberupdated.py. LGPL-3.0-or-later; see LICENSE.

"""A chat member's before/after state and the action that changed it."""

from std.collections import List
from std.collections.optional import Optional
from std.hashlib.hasher import Hasher

from telegram._chat import Chat
from telegram._chatinvitelink import ChatInviteLink
from telegram._chatmember import ChatMember
from telegram._telegramobject import TelegramJsonObject
from telegram._user import User
from telegram._utils.datetime import TimestampDateTime, from_timestamp, to_timestamp
from telegram._utils.json import JSON_BOOL, JSON_OBJECT, JsonDocument, dumps_json
from telegram._utils.json_model import empty_json_object


def _chatmemberupdated_nested(data: JsonDocument, index: Int) raises -> JsonDocument:
    var result = JsonDocument()
    result.root = result.copy_subtree_from(data, index)
    return result^


def _chatmemberupdated_api_kwargs(data: JsonDocument) raises -> JsonDocument:
    var result = empty_json_object()
    var child = data.nodes[data.root].first_child
    while child != -1:
        var key = data.nodes[child].name
        var known = (
            key == "chat" or key == "date" or key == "from" or key == "invite_link"
            or key == "new_chat_member" or key == "old_chat_member"
            or key == "via_chat_folder_invite_link" or key == "via_join_request"
        )
        if not known:
            var copied = result.copy_subtree_from(data, child)
            result.object_set(result.root, key.copy(), copied)
        child = data.nodes[child].next_sibling
    return result^


def _chatmemberupdated_has_changed(
    first: JsonDocument, first_index: Int, second: JsonDocument, second_index: Int
) raises -> Bool:
    if first_index == -1 or second_index == -1:
        return first_index != second_index
    var first_value = _chatmemberupdated_nested(first, first_index)
    var second_value = _chatmemberupdated_nested(second, second_index)
    return dumps_json(first_value) != dumps_json(second_value)


def _chatmemberupdated_add_difference(
    mut target: JsonDocument,
    key: String,
    old_data: JsonDocument,
    old_index: Int,
    new_data: JsonDocument,
    new_index: Int,
) raises:
    var values = target.add_array()
    target.object_set(target.root, key, values)
    if old_index == -1:
        target.append_child(values, target.add_null())
    else:
        var old_value = target.copy_subtree_from(old_data, old_index)
        target.append_child(values, old_value)
    if new_index == -1:
        target.append_child(values, target.add_null())
    else:
        var new_value = target.copy_subtree_from(new_data, new_index)
        target.append_child(values, new_value)


struct ChatMemberUpdated(Equatable, Hashable, Copyable, TelegramJsonObject):
    """Membership-change event; equality follows chat, actor, date, and both member states."""

    var chat: Chat
    var from_user: User
    var date: TimestampDateTime
    var old_chat_member: ChatMember
    var new_chat_member: ChatMember
    var invite_link: Optional[ChatInviteLink]
    var via_chat_folder_invite_link: Optional[Bool]
    var via_join_request: Optional[Bool]
    var api_kwargs: JsonDocument

    def __init__(
        out self,
        chat: Chat,
        from_user: User,
        date: TimestampDateTime,
        old_chat_member: ChatMember,
        new_chat_member: ChatMember,
        invite_link: Optional[ChatInviteLink] = None,
        via_chat_folder_invite_link: Optional[Bool] = None,
        via_join_request: Optional[Bool] = None,
    ):
        self.chat = chat.copy()
        self.from_user = from_user.copy()
        self.date = date.copy()
        self.old_chat_member = old_chat_member.copy()
        self.new_chat_member = new_chat_member.copy()
        self.invite_link = invite_link.copy()
        self.via_chat_folder_invite_link = via_chat_folder_invite_link
        self.via_join_request = via_join_request
        self.api_kwargs = empty_json_object()

    def __init__(
        out self,
        chat: Chat,
        from_user: User,
        date: TimestampDateTime,
        old_chat_member: ChatMember,
        new_chat_member: ChatMember,
        invite_link: Optional[ChatInviteLink],
        via_chat_folder_invite_link: Optional[Bool],
        via_join_request: Optional[Bool],
        *,
        api_kwargs: JsonDocument,
    ):
        self.chat = chat.copy()
        self.from_user = from_user.copy()
        self.date = date.copy()
        self.old_chat_member = old_chat_member.copy()
        self.new_chat_member = new_chat_member.copy()
        self.invite_link = invite_link.copy()
        self.via_chat_folder_invite_link = via_chat_folder_invite_link
        self.via_join_request = via_join_request
        self.api_kwargs = api_kwargs.copy()

    def __copyinit__(out self, existing: Self):
        self.chat = existing.chat.copy()
        self.from_user = existing.from_user.copy()
        self.date = existing.date.copy()
        self.old_chat_member = existing.old_chat_member.copy()
        self.new_chat_member = existing.new_chat_member.copy()
        self.invite_link = existing.invite_link.copy()
        self.via_chat_folder_invite_link = existing.via_chat_folder_invite_link
        self.via_join_request = existing.via_join_request
        self.api_kwargs = existing.api_kwargs.copy()

    def __eq__(self, other: Self) -> Bool:
        return (
            self.chat == other.chat and self.from_user == other.from_user
            and self.date == other.date and self.old_chat_member == other.old_chat_member
            and self.new_chat_member == other.new_chat_member
        )

    def __hash__[H: Hasher](self, mut hasher: H):
        hasher.update(String(self.chat.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(self.from_user.id).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.date)).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.old_chat_member)).as_bytes())
        hasher.update(String("\0").as_bytes())
        hasher.update(String(hash(self.new_chat_member)).as_bytes())

    def to_dict(self, recursive: Bool = True) raises -> JsonDocument:
        var result = empty_json_object()
        var chat_data = self.chat.to_dict(recursive)
        var chat_node = result.copy_subtree_from(chat_data, chat_data.root)
        result.object_set(result.root, "chat", chat_node)
        result.set_number(result.root, "date", String(to_timestamp(self.date)))
        var from_data = self.from_user.to_dict(recursive)
        var from_node = result.copy_subtree_from(from_data, from_data.root)
        result.object_set(result.root, "from", from_node)
        if self.invite_link is not None:
            var invite_data = self.invite_link.value().to_dict(recursive)
            var invite_node = result.copy_subtree_from(invite_data, invite_data.root)
            result.object_set(result.root, "invite_link", invite_node)
        var new_data = self.new_chat_member.to_dict(recursive)
        var new_node = result.copy_subtree_from(new_data, new_data.root)
        result.object_set(result.root, "new_chat_member", new_node)
        var old_data = self.old_chat_member.to_dict(recursive)
        var old_node = result.copy_subtree_from(old_data, old_data.root)
        result.object_set(result.root, "old_chat_member", old_node)
        if self.via_chat_folder_invite_link is not None:
            result.set_boolean(
                result.root, "via_chat_folder_invite_link",
                self.via_chat_folder_invite_link.value(),
            )
        if self.via_join_request is not None:
            result.set_boolean(result.root, "via_join_request", self.via_join_request.value())
        result.merge_object(result.root, self.api_kwargs.copy(), self.api_kwargs.root)
        return result^

    def to_json(self) raises -> String:
        return dumps_json(self.to_dict())

    def difference(self) raises -> JsonDocument:
        """Return changed member fields as a JSON object mapping keys to two-item arrays.

        The ``user`` entry contains the old and new serialized User values. Missing
        fields are represented by JSON null in the corresponding array position.
        """
        var old_data = self.old_chat_member.to_dict()
        var new_data = self.new_chat_member.to_dict()
        var result = empty_json_object()
        var child = old_data.nodes[old_data.root].first_child
        while child != -1:
            var key = old_data.nodes[child].name
            if key != "user":
                var new_index = new_data.object_get(new_data.root, key)
                if _chatmemberupdated_has_changed(old_data, child, new_data, new_index):
                    _chatmemberupdated_add_difference(
                        result, key.copy(), old_data, child, new_data, new_index
                    )
            child = old_data.nodes[child].next_sibling
        child = new_data.nodes[new_data.root].first_child
        while child != -1:
            var key = new_data.nodes[child].name
            if key != "user" and old_data.object_get(old_data.root, key) == -1:
                _chatmemberupdated_add_difference(result, key.copy(), old_data, -1, new_data, child)
            child = new_data.nodes[child].next_sibling
        var old_user = self.old_chat_member.user.to_dict()
        var new_user = self.new_chat_member.user.to_dict()
        if dumps_json(old_user) != dumps_json(new_user):
            _chatmemberupdated_add_difference(
                result, "user", old_user, old_user.root, new_user, new_user.root
            )
        return result^

    @staticmethod
    def de_json(data: JsonDocument) raises -> Self:
        if data.root < 0 or data.root >= len(data.nodes) or data.nodes[data.root].kind != JSON_OBJECT:
            raise Error("ChatMemberUpdated JSON value must be an object")
        var chat_index = data.object_get(data.root, "chat")
        var from_index = data.object_get(data.root, "from")
        var date_index = data.object_get(data.root, "date")
        var old_index = data.object_get(data.root, "old_chat_member")
        var new_index = data.object_get(data.root, "new_chat_member")
        if (
            chat_index == -1 or from_index == -1 or date_index == -1
            or old_index == -1 or new_index == -1
        ):
            raise Error("ChatMemberUpdated JSON object is missing a required field")
        var chat = Chat.de_json(_chatmemberupdated_nested(data, chat_index))
        var from_user = User.de_json(_chatmemberupdated_nested(data, from_index))
        var date = from_timestamp(data.integer_value(date_index))
        var old_member = ChatMember.de_json(_chatmemberupdated_nested(data, old_index))
        var new_member = ChatMember.de_json(_chatmemberupdated_nested(data, new_index))
        var invite_link: Optional[ChatInviteLink] = None
        var invite_index = data.object_get(data.root, "invite_link")
        if invite_index != -1 and not data.is_null(invite_index):
            invite_link = Optional[ChatInviteLink](
                ChatInviteLink.de_json(_chatmemberupdated_nested(data, invite_index))
            )
        var folder: Optional[Bool] = None
        var folder_index = data.object_get(data.root, "via_chat_folder_invite_link")
        if folder_index != -1 and not data.is_null(folder_index):
            if data.nodes[folder_index].kind != JSON_BOOL:
                raise Error("ChatMemberUpdated via_chat_folder_invite_link must be Boolean")
            folder = Optional[Bool](data.boolean_value(folder_index))
        var join_request: Optional[Bool] = None
        var join_index = data.object_get(data.root, "via_join_request")
        if join_index != -1 and not data.is_null(join_index):
            if data.nodes[join_index].kind != JSON_BOOL:
                raise Error("ChatMemberUpdated via_join_request must be Boolean")
            join_request = Optional[Bool](data.boolean_value(join_index))
        return Self(
            chat, from_user, date, old_member, new_member, invite_link, folder,
            join_request, api_kwargs=_chatmemberupdated_api_kwargs(data),
        )

    @staticmethod
    def de_list(data: JsonDocument, array_index: Int) raises -> List[Self]:
        var items = data.array_documents(array_index)
        var result = List[Self]()
        for item in items:
            result.append(Self.de_json(item))
        return result^
