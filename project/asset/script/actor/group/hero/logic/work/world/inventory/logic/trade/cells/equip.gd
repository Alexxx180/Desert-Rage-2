extends Node

var logic: Node
var bank: Dictionary
var space: Dictionary = Defaults.DICT
var select: Dictionary:
	get: return bank[space.id][space.x - 1]

var available: bool:
	get: return space != Defaults.DICT 

func _slot() -> Dictionary: return { "equip": [], "cross": Defaults.DICT }
func _equip(slot: int) -> Dictionary:
	var id: int = logic.slot(slot).id
	return { "item": logic.item(id), "id": id }

func select_weapon(slot: int) -> void:
	space = logic.slot(slot).duplicate()

func _tail_to_bank(id: int, slot: Dictionary) -> int:
	if bank.has(id):
		bank[id].append(slot)
	else:
		bank[id] = [slot]
	return len(bank[id])

func add_weapon(slot: int) -> void:
	var meta: Dictionary = logic.slot(slot)
	if logic.items.items.is_equipable(meta.id):
		meta.x = _tail_to_bank(meta.id, _slot())

func add_slot(slot: int) -> void:
	select.equip.append(_equip(slot))

func add_cross(slot: int) -> void:
	select.cross = logic.slot(slot).duplicate()
