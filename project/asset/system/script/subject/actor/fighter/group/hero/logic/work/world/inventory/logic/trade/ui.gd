extends Node

var ui: Node
var trade: Node
var title: Array[HBoxContainer] = []
var size: int
var slots: Array:
	get: return trade.craft.slots.slots

func _drag(cell: CellDrag) -> void:
	cell.drag = trade.drag
	cell.slot = size
	size += 1

func _add_ui(res: Array, ui: Variant, iterator: Callable) -> void:
	res.append(ui)
	iterator.call(func(i): _drag(i.margin.view))

func set_items(bag: HFlowContainer) -> void:
	size = ui.EMPTY
	_add_ui(ui.inventory, bag.get_children().slice(ui.EMPTY, ui.SLOTS), 
		func(f): for item in ui.inventory.back(): f.call(item))
	_add_ui(title, bag.title, func(f): f.call(bag.title.slot))
	bag.title.workspace.cancel.trade = trade

func _t(f: Callable) -> void: for t in title: f.call(t)

func describe(item: Variant): _t(func(t): t.describe(item))
func equipment(): _t(func(t): t.equipment(
	trade.equip.select.equip, trade.equipped()))
func production(): _t(func(t): t.production(slots))
func product(item: Dictionary): _t(func(t): t.put_product(item))
func helping() -> void: _t(func(t): t.helping())
