extends Node

var inventory: HFlowContainer
var description: Label

enum { NONE = -1, EMPTY = 0, UNIT = 1, MAX = 30 }

func update_item(slot: int, item: Dictionary) -> void:
	if item.x == EMPTY:
		inventory.items[slot].remove_item()
	else:
		inventory.items[slot].put_item(item)

func have(slot: int) -> bool: return slot != NONE

func is_empty(item: Dictionary) -> bool: return item.x == EMPTY

func same_item(id: int, item: Dictionary) -> bool:
	return item.id == id

func find_item_or_slot(storage: Array, id: int) -> int:
	var slot: int = NONE
	for i in range(0, len(storage)):
		var item: Dictionary = storage[i]
		if not have(slot) and is_empty(item):
			slot = i
		if same_item(id, item) and item.x < MAX:
			return i
	return slot

func find_same_item(storage: Array, id: int) -> int:
	for i in range(0, len(storage)):
		var item: Dictionary = storage[i]
		if same_item(id, item) and item.x > EMPTY:
			return i
	return NONE

func find_empty_slot(storage: Array) -> int:
	for i in range(0, len(storage)):
		if is_empty(storage[i]):
			return i
	return NONE

func use_item(slot: int, item: Dictionary) -> void:
	item.x -= UNIT
	update_item(slot, item)

func add_item(slot: int, item: Dictionary) -> void:
	item.x += UNIT
	inventory.items[slot].put_item(item)

func put_item(slot: int, item: Dictionary, id: int) -> void:
	item.id = id
	add_item(slot, item)
