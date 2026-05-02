extends Node

@onready var search: Node = $search

var preview: Node

func make_slot(slot: int) -> Dictionary:
	return search.form(slot, search.logic.slot(slot))

func _can_product(cells: Array, slots: Array) -> bool:
	for i in len(slots):
		if not search.item_slot(slots[i]):
			return false
		cells.append(search.item)
	return true

func craft(slots: Array) -> void:
	var cells: Array = []
	if _can_product(cells, slots):
		search.put_crafted_item(cells, preview.craft_id)
	else:
		search.default_message()
