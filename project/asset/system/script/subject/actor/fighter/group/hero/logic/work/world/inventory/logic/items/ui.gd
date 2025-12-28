extends Node

enum { NONE = -1, UNIT = 1, EMPTY = 0, MAX = 30 }

var inventory: Array # [HFlowContainer] # : HFlowContainer

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

func remove_item(slot: int) -> void:
	for ui in inventory: ui.items[slot].remove_item()

func put_item(slot: int, item: Dictionary) -> void:
	for ui in inventory: ui.items[slot].put_item(item)

func helping() -> void: for ui in inventory: ui.title.helping()
func describe(item: Variant) -> void:
	for ui in inventory: ui.title.describe(item)

func update_item(slot: int, item: Dictionary) -> void:
	if is_empty(item):
		remove_item(slot)
	else:
		put_item(slot, item)
