extends Node

var storage: Array
@onready var items: Node = $items

func update_inventory_storage() -> void:
	var slot = len(storage)
	while slot > 0:
		slot -= 1
		items.update_item(slot, storage[slot])

func use_inventory(slot: int) -> void:
	storage[slot].x -= items.UNIT
	items.update_item(slot, storage[slot])

func put_to_inventory(no: int) -> bool:
	var slot: int
	if no in [0, 1]:
		slot = items.find_item_or_slot(storage, no)
	else:
		slot = items.find_empty_slot(storage)
	if slot != items.NONE:
		items.put_item(slot, storage[slot], no)
		return true
	return false

func fill_the_jar() -> void:
	var water: int = items.find_item_or_slot(storage, 1)
	if items.have(water):
		var jar: int = items.find_same_item(storage, 0)
		if items.have(jar):
			items.use_item(jar, storage[jar])
			items.put_item(water, storage[water], 1)

func remember_inventory(no: int) -> void:
	pass
