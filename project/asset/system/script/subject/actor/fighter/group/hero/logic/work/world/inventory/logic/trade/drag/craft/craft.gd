extends Node

@onready var selection: Node = $selection

var trade: Node
var select: Node

func select_to_craft(ui: Button) -> bool:
	if not select.is_selected():
		select.from_ui(ui.margin.view)
	else:
		trade.craft.one_item(select.main)
	return true

func is_product(ui: Button) -> bool:
	return ui.margin.view.slot == select.CRAFT

func items(ui: Button) -> bool:
	if select.was_selected(): return trade.craft.one_slot(select.main)
	if is_product(ui): return select_to_craft(ui)
	return false
