#!/usr/bin/env mojo
#
# Native tracking mapping corresponding to python-telegram-bot v22.8.
# LGPL-3.0-or-later; see LICENSE.

"""A typed mapping that records keys changed since the last drain."""

from std.collections import Dict, List
from std.collections.optional import Optional


struct _TrackingEntry[
    Key: Copyable & Equatable & Hashable & Deinitable,
    Value: Copyable & Deinitable,
](Copyable):
    var key: Self.Key
    var value: Self.Value

    def __init__(out self, key: Self.Key, value: Self.Value):
        self.key = key.copy()
        self.value = value.copy()


struct TrackingWriteItem[
    Key: Copyable & Equatable & Hashable & Deinitable,
    Value: Copyable & Deinitable,
](Copyable):
    """Typed replacement for a ``(key, value-or-DELETED)`` tracking entry."""

    var key: Self.Key
    var value: Optional[Self.Value]
    var is_deleted: Bool

    def __init__(
        out self,
        key: Self.Key,
        value: Optional[Self.Value],
        is_deleted: Bool,
    ):
        self.key = key.copy()
        self.value = value.copy()
        self.is_deleted = is_deleted


struct TrackingPair[
    Key: Copyable & Equatable & Hashable & Deinitable,
    Value: Copyable & Deinitable,
](Copyable):
    """Native key/value pair returned by ``popitem``."""

    var key: Self.Key
    var value: Self.Value

    def __init__(out self, key: Self.Key, value: Self.Value):
        self.key = key.copy()
        self.value = value.copy()


struct TrackingDict[
    Key: Copyable & Equatable & Hashable & Deinitable,
    Value: Copyable & Deinitable,
]:
    """Mutable typed mapping with write-access tracking.

    Reads are untracked. Assignments, deletions, and mutating helpers track keys;
    ``clear`` tracks all keys that existed before it ran.
    """

    # List-backed storage avoids generic Optional destruction problems in Mojo's
    # Dict/Set APIs and preserves the mapping's observable key/value behavior.
    var data: List[_TrackingEntry[Self.Key, Self.Value]]
    var _write_access_keys: List[Self.Key]

    def __init__(out self):
        self.data = List[_TrackingEntry[Self.Key, Self.Value]]()
        self._write_access_keys = List[Self.Key]()

    def _index_for(self, key: Self.Key) -> Int:
        for i in range(len(self.data)):
            if self.data[i].key == key:
                return i
        return -1

    def _track(mut self, key: Self.Key):
        for existing in self._write_access_keys:
            if existing == key:
                return
        self._write_access_keys.append(key.copy())

    def __len__(self) -> Int:
        return len(self.data)

    def __contains__(self, key: Self.Key) -> Bool:
        return self._index_for(key) >= 0

    def keys(self) -> List[Self.Key]:
        """Return a native snapshot of the mapping's keys in insertion order."""
        var result = List[Self.Key]()
        for i in range(len(self.data)):
            result.append(self.data[i].key.copy())
        return result^

    def values(self) -> List[Self.Value]:
        """Return a native snapshot of the mapping's values in insertion order."""
        var result = List[Self.Value]()
        for i in range(len(self.data)):
            result.append(self.data[i].value.copy())
        return result^

    def items(self) -> List[TrackingPair[Self.Key, Self.Value]]:
        """Return a native snapshot of the mapping's key/value pairs."""
        var result = List[TrackingPair[Self.Key, Self.Value]]()
        for i in range(len(self.data)):
            result.append(
                TrackingPair[Self.Key, Self.Value](
                    self.data[i].key, self.data[i].value
                )
            )
        return result^

    def get_item(self, key: Self.Key) raises -> Self.Value:
        var index = self._index_for(key)
        if index < 0:
            raise Error("TrackingDict key was not found")
        return self.data[index].value.copy()

    def __getitem__(self, key: Self.Key) raises -> Self.Value:
        return self.get_item(key)

    def set_item(mut self, key: Self.Key, value: Self.Value):
        self._track(key)
        var index = self._index_for(key)
        if index < 0:
            self.data.append(_TrackingEntry[Self.Key, Self.Value](key, value))
        else:
            self.data[index].value = value.copy()

    def __setitem__(mut self, key: Self.Key, value: Self.Value):
        self.set_item(key, value)

    def delete_item(mut self, key: Self.Key) raises:
        # Upstream records an attempted write before the underlying mapping
        # raises for an absent key.
        self._track(key)
        var index = self._index_for(key)
        if index < 0:
            raise Error("TrackingDict key was not found")
        _ = self.data.pop(index)

    def __delitem__(mut self, key: Self.Key) raises:
        self.delete_item(key)

    def pop(mut self, key: Self.Key) raises -> Self.Value:
        var index = self._index_for(key)
        if index < 0:
            raise Error("TrackingDict key was not found")
        self._track(key)
        var removed = self.data.pop(index)
        return removed.value.copy()

    def pop(mut self, key: Self.Key, default: Self.Value) raises -> Self.Value:
        var index = self._index_for(key)
        if index < 0:
            return default.copy()
        self._track(key)
        var removed = self.data.pop(index)
        return removed.value.copy()

    def pop(mut self, key: Self.Key, default: None) raises -> Optional[Self.Value]:
        var index = self._index_for(key)
        if index < 0:
            return None
        self._track(key)
        var removed = self.data.pop(index)
        return Optional[Self.Value](removed.value.copy())

    def popitem(mut self) raises -> TrackingPair[Self.Key, Self.Value]:
        """Remove and return the first key/value pair, preserving upstream FIFO order."""
        if len(self.data) == 0:
            raise Error("TrackingDict is empty")
        var key = self.data[0].key.copy()
        var value = self.data[0].value.copy()
        self._track(key)
        _ = self.data.pop(0)
        return TrackingPair[Self.Key, Self.Value](key, value)

    def setdefault(mut self, key: Self.Key, default: Self.Value) -> Self.Value:
        var index = self._index_for(key)
        if index >= 0:
            return self.data[index].value.copy()
        self._track(key)
        self.data.append(_TrackingEntry[Self.Key, Self.Value](key, default))
        return default.copy()

    def pop_accessed_keys(mut self) -> List[Self.Key]:
        var result = self._write_access_keys^
        self._write_access_keys = List[Self.Key]()
        return result^

    def pop_accessed_write_items(
        mut self,
    ) -> List[TrackingWriteItem[Self.Key, Self.Value]]:
        var keys = self.pop_accessed_keys()
        var result = List[TrackingWriteItem[Self.Key, Self.Value]]()
        for key in keys:
            var index = self._index_for(key)
            if index < 0:
                result.append(
                    TrackingWriteItem[Self.Key, Self.Value](key, None, True)
                )
            else:
                result.append(
                    TrackingWriteItem[Self.Key, Self.Value](
                        key,
                        Optional[Self.Value](self.data[index].value.copy()),
                        False,
                    )
                )
        return result^

    def mark_as_accessed(mut self, key: Self.Key):
        self._track(key)

    def update_no_track(mut self, mapping: Dict[Self.Key, Self.Value]):
        for item in mapping.items():
            var index = self._index_for(item.key)
            if index < 0:
                self.data.append(
                    _TrackingEntry[Self.Key, Self.Value](item.key, item.value)
                )
            else:
                self.data[index].value = item.value.copy()

    def update(mut self, mapping: Dict[Self.Key, Self.Value]):
        """Insert or replace each item, recording every changed key."""
        for item in mapping.items():
            self.set_item(item.key, item.value)

    def clear(mut self):
        for i in range(len(self.data)):
            var key = self.data[i].key.copy()
            self._track(key)
        self.data.clear()
