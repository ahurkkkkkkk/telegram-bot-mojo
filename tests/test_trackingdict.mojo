from std.collections import Dict
from std.testing import assert_equal, assert_raises

from telegram.ext._utils.trackingdict import TrackingDict


def main() raises:
    var tracking = TrackingDict[String, Int]()
    assert_equal(tracking.__len__(), 0)
    assert_equal("missing" in tracking, False)

    tracking["one"] = 1
    tracking["one"] = 4
    assert_equal(tracking.get_item("one"), 4)
    assert_equal(tracking["one"], 4)
    assert_equal(len(tracking.pop_accessed_keys()), 1)
    var initial_keys = tracking.keys()
    var initial_values = tracking.values()
    var initial_items = tracking.items()
    assert_equal(len(initial_keys), 1)
    assert_equal(initial_keys[0], "one")
    assert_equal(initial_values[0], 4)
    assert_equal(initial_items[0].key, "one")

    var tracked_update = TrackingDict[String, Int]()
    var tracked_values = Dict[String, Int]()
    tracked_values["tracked"] = 7
    tracked_update.update(tracked_values)
    assert_equal(tracked_update.get_item("tracked"), 7)
    assert_equal(len(tracked_update.pop_accessed_keys()), 1)

    var fifo = TrackingDict[String, Int]()
    fifo.set_item("fifo-one", 11)
    fifo.set_item("fifo-two", 12)
    _ = fifo.pop_accessed_keys()
    var first_popped = fifo.popitem()
    assert_equal(first_popped.key, "fifo-one")
    assert_equal(first_popped.value, 11)
    var second_popped = fifo.popitem()
    assert_equal(second_popped.key, "fifo-two")
    var popitem_writes = fifo.pop_accessed_write_items()
    assert_equal(len(popitem_writes), 2)
    assert_equal(popitem_writes[0].is_deleted, True)
    assert_equal(popitem_writes[1].is_deleted, True)

    var seed = Dict[String, Int]()
    seed["untracked"] = 3
    tracking.update_no_track(seed)
    assert_equal(tracking.get_item("untracked"), 3)
    assert_equal(len(tracking.pop_accessed_keys()), 0)

    assert_equal(tracking.setdefault("untracked", 9), 3)
    assert_equal(len(tracking.pop_accessed_keys()), 0)
    assert_equal(tracking.setdefault("two", 2), 2)
    var setdefault_writes = tracking.pop_accessed_write_items()
    assert_equal(len(setdefault_writes), 1)
    assert_equal(setdefault_writes[0].key, "two")
    assert_equal(setdefault_writes[0].value.value(), 2)
    assert_equal(setdefault_writes[0].is_deleted, False)

    assert_equal(tracking.pop("one", 10), 4)
    var popped = tracking.pop_accessed_write_items()
    assert_equal(len(popped), 1)
    assert_equal(popped[0].key, "one")
    assert_equal(popped[0].is_deleted, True)
    assert_equal(tracking.pop("absent", 10), 10)
    assert_equal(len(tracking.pop_accessed_keys()), 0)

    var optional_pop = TrackingDict[String, Int]()
    optional_pop.set_item("value", 5)
    _ = optional_pop.pop_accessed_keys()
    var present_value = optional_pop.pop("value", None)
    assert_equal(present_value is not None, True)
    assert_equal(present_value.value(), 5)
    var absent_value = optional_pop.pop("absent", None)
    assert_equal(absent_value is None, True)
    assert_equal(len(optional_pop.pop_accessed_keys()), 1)

    tracking.mark_as_accessed("absent")
    var marked = tracking.pop_accessed_write_items()
    assert_equal(len(marked), 1)
    assert_equal(marked[0].is_deleted, True)

    with assert_raises():
        tracking.delete_item("never-present")
    var failed_delete = tracking.pop_accessed_write_items()
    assert_equal(len(failed_delete), 1)
    assert_equal(failed_delete[0].key, "never-present")
    assert_equal(failed_delete[0].is_deleted, True)

    tracking.clear()
    var clear_writes = tracking.pop_accessed_write_items()
    assert_equal(len(clear_writes), 2)
    assert_equal(tracking.__len__(), 0)
