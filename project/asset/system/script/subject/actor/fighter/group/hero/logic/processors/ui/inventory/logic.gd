extends Node

var storage: Array[Dictionary]
var inventory: HFlowContainer

enum { NONE = -1, EMPTY = 0, UNIT = 1 }

func update_inventory_storage() -> void:
	
	pass # UPDATE DEFAULT INVENTORY STATE

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
		if storage[i].id == no:
			slot = i
			break
	if slot != NONE:
		storage[slot].id = no
		storage[slot].x += UNIT
		inventory.items[slot].put_item(storage[slot])
		return true
	return false

func show_inventory(no: int) -> void:
	pass
