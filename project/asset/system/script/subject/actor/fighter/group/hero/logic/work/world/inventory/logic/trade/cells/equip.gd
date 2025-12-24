extends Node

var base: Dictionary

var equip: Node
var slots: Array[int] = []

func busy() -> bool: return slots.size() >= base.max
func reset() -> void: slots.clear()

func add_slot(slot: int) -> void:
	equip.reset()
	slots.append(slot)
	if busy(): reset()
