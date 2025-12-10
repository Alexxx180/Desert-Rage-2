extends Node

@onready var ui: Node = $ui

var description: Label

func decide_item_or_equipment(storage: Array, id: int) -> int:
	if id in [0, 1]:
		return find_item_or_slot(storage, id)
	else:
		return find_empty_slot(storage)

func find_item_or_slot(storage: Array, id: int) -> int:
	var slot: int = ui.NONE
	for i in range(0, len(storage)):
		var item: Dictionary = storage[i]
		if ui.empty_slot_search(slot, item): slot = i
		if ui.same_slot_search(id, item): return i
	return slot

func find_same_item(storage: Array, id: int) -> int:
	for i in range(0, len(storage)):
		if ui.same_item_search(id, storage[i]): return i
	return ui.NONE

func find_empty_slot(storage: Array) -> int:
	for i in range(0, len(storage)):
		if ui.is_empty(storage[i]): return i
	return ui.NONE

func use_item(slot: int, item: Dictionary) -> void:
	item.x -= ui.UNIT
	ui.update_item(slot, item)

func add_item(slot: int, item: Dictionary) -> void:
	item.x += ui.UNIT
	ui.put_item(slot, item)

func put_item(slot: int, item: Dictionary, id: int) -> void:
	item.id = id
	add_item(slot, item)
