extends Node

var item: Dictionary = Defaults.DICT
var _cost: int = Defaults.INT
var logic: Node

func get_id(slot: int) -> int: return logic.slot(slot).id

func default_message() -> void: logic.items.ui.helping()

func form(no: int, cell: Dictionary) -> Dictionary:
	return { "slot": no, "id": cell.id, "cell": cell, "item": logic.item(cell.id) }

func _find_item(algorithm: String, id: int, feedback: Callable) -> bool:
	var slot: int = logic.items.get(algorithm).call(id)
	if logic.items.ui.have(slot):
		feedback.call(slot)
		return true
	return false

func same_item() -> bool:
	return _find_item("find_same_item", item.id, func(s): item.cell = logic.slot(s))

func same_slot() -> bool:
	return logic.items.ui.same_item_search(item.id, logic.slot(item.slot))

func item_slot(_item: Dictionary) -> bool:
	item = _item
	return same_slot() or same_item()

func _minimum(i: Dictionary) -> void:
	if i.cell.x < _cost: _cost = i.cell.x

func _put_items(i: Dictionary) -> void:
	logic.items.put_items(i.slot, i.id, i.cell.x - _cost)

func _iterate(items: Array, feedback: Callable) -> void:
	for i in items: feedback.call(i)

func min_cell(items: Array) -> int:
	_cost = logic.items.ui.MAX
	for f in [_minimum, _put_items]: _iterate(items, f)
	return _cost

func put_crafted_item(cells: Array, id: int) -> void:
	_find_item("find_item_or_slot", id, func(slot):
		logic.items.put_items(slot, id, min_cell(cells)))
