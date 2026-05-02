extends Node

enum { NONE = -1, UNIT = 1, EMPTY = 0, SLOTS = 25, MAX = 30 }

var inventory: Array = []

func have(slot: int) -> bool: return slot != NONE

func same(id: int, item: Dictionary) -> bool: return item.id == id

func is_empty(item: Dictionary) -> bool: return item.x == EMPTY

func is_maxed(item: Dictionary) -> bool: return item.x >= MAX

func empty_slot_search(slot: int, item: Dictionary) -> bool:
	return not have(slot) and is_empty(item)

func same_slot_search(id: int, item: Dictionary) -> bool:
	return same(id, item) and not is_maxed(item)

func same_item_search(id: int, item: Dictionary) -> bool:
	return same(id, item) and not is_empty(item)

func _u(slot: int, f: Callable): for ui in inventory: f.call(ui[slot])

func remove_item(no): _u(no, func(u): u.remove_item())
func put_item(no, item: Dictionary): _u(no, func(u): u.put_item(item))

func repair_id_for_search(item: Dictionary) -> void: item.id = EMPTY

func update_item(slot: int, item: Dictionary) -> void:
	if is_empty(item):
		repair_id_for_search(item)
		remove_item(slot)
	else:
		put_item(slot, item)
