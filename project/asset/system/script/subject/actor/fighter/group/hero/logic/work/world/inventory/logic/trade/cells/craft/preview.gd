extends Node

signal show()

enum { SECOND = 1, MIN = 2 }

var craft_id: int = Defaults.INT

func reset_id() -> void: craft_id = Defaults.INT

func _assert_craft(products: Dictionary, items: Array) -> void:
	if products[craft_id].o.size() != items.size():
		reset_id()
	else:
		show.emit()

func _has_slots(items: Array, found: bool, flow: Callable, search: Callable) -> bool:
	var i: int = len(items)
	while flow.call(found, i):
		i -= 1
		found = search.call(found, i) # craft_id in items[j].o
	return found

func _has_first_slot(items: Array) -> bool:
	var first: Dictionary = items.front()
	return _has_slots(first.o, false, func(f, i): return i > 0 and not f,
		func(f, i):
			f = first.o[i] in items[SECOND].o
			if f: craft_id = i
			return f)

func _has_other_slots(items: Array) -> bool:
	return _has_slots(items, true, func(f, i): i > MIN and f,
		func(_f, i): craft_id in items[i].o)

func slots(logic: Node, items: Array) -> void:
	if items.size() < MIN: return
	
	if _has_first_slot(items) and _has_other_slots(items):
		_assert_craft(logic.items.items.crafting.craft, items)
	else:
		reset_id()
