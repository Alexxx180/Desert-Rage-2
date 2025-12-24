extends Node

const MAX: int = 2

var items: Node
var craft: Node
var slots: Array[int] = []

func busy() -> bool: return slots.size() >= MAX
func reset() -> void: slots.clear()

func add_slot(slot: int) -> void:
	craft.reset()
	slots.append(slot)
	if busy(): reset()
