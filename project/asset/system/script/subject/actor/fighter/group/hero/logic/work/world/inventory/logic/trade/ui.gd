extends Node

var items: Array[Node] = []
var size: int = 0

func describe(cell: Control, drag: Node) -> void:
	cell.drag = drag
	cell.slot = size
	size += 1

func set_items(bag: HFlowContainer) -> void: # var inventory: Node = group.get(hero).to.inventory # hero: String, , group: Node2D
	var trade: Node = get_parent()
	items = get_children().slice(0, InventoryItem.CRAFT)
	
	for item in items: describe(item.margin.view, trade.drag)
	describe(bag.title.slot.margin.view, trade.drag)
