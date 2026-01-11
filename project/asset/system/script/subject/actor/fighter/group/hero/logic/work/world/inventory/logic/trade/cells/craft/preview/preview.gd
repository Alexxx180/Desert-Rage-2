extends Node

@onready var cells: Node = $cells

func _has_first(items: Array) -> bool:
	return cells.check(cells.recipe(items), cells.first, cells.set_id, 0)

func _has_other(items: Array) -> bool:
	return cells.check(items, cells.other, Defaults.FUNC, cells.MIN)

func reset_id() -> bool:
	cells.set_id(Defaults.INT)
	return false

func complete_product(logic: Node, items: Array) -> bool:
	if cells.matches(logic, items): return true
	return reset_id()

func slots(logic: Node, items: Array) -> bool:
	if items.size() < cells.MIN: return false
	
	if not _has_first(items): return reset_id()
	if items.size() == cells.MIN: return complete_product(logic, items)
	
	if not _has_other(items): return reset_id()
	return complete_product(logic, items)
