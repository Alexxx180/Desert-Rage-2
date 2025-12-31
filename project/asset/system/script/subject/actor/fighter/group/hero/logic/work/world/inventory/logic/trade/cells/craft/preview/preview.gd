extends Node

@onready var cells: Node = $cells

func _has_first(items: Array) -> bool:
	return cells.check(cells.recipe(items), cells.first, cells.set_id, 0)

func _has_other(items: Array) -> bool:
	return cells.check(items, cells.other, Defaults.FUNC, cells.MIN)

func slots(logic: Node, items: Array) -> bool:
	if items.size() < cells.MIN: return false
	
	var craft: Dictionary = logic.items.items.crafting.craft
	if _has_first(items) and _has_other(items) and cells.matches(craft, items):
		return true
	
	cells.set_id(Defaults.INT)
	return false
