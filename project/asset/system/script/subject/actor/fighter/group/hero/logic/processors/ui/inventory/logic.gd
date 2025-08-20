extends Node

var storage: Array
var inventory: HFlowContainer

enum { NONE = -1, EMPTY = 0, UNIT = 1, MAX = 30 }

func update_inventory_storage() -> void:
	var slot = len(storage)
	while slot > 0:
		slot -= 1
		var item: Dictionary = storage[slot]
		if item.x != EMPTY:
			inventory.items[slot].put_item(item)
	# pass # UPDATE DEFAULT INVENTORY STATE

func use_inventory(slot: int) -> void:
	var item: Dictionary = storage[slot]
	item.x -= UNIT
	if item.x == EMPTY:
		inventory.items[slot].remove_item(item)
	else:
		inventory.items[slot].put_item(item)

func put_to_inventory(no: int) -> bool:
	var slot: int = NONE
	for i in range(0, len(storage)):
		if slot == NONE and storage[i].x == EMPTY:
			slot = i
		if storage[i].id == no and storage[i].x < MAX:
			slot = i
			break
	if slot != NONE:
		storage[slot].id = no
		storage[slot].x += UNIT
		inventory.items[slot].put_item(storage[slot])
		return true
	return false

func remember_inventory(no: int) -> void:
	pass
