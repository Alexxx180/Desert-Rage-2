extends Node

var select: Node
var craft: Node
var drag: Node

func _release_item(view: CellDrag) -> void:
	drag.trade(view)#select.main.bag.logic, select.main.slot)
	select.reset_selection()

func craft_all_items() -> void: pass

func craft_more_items(slot: int) -> void:
	craft.one_slot(slot)
	select.reset_selection()

func hold_selection(view: Control) -> void:
	select.set_selection(view.drag.inventory, view.slot)

func craft_one_item(_v) -> void: craft.one_item(select.main)

func equiping_items() -> bool: return false

func crafting_items(view: Control) -> bool:
	if select.is_space():
		drag.craft.trade.trades(view)
		return true
	if select.was_selected():
		craft_more_items(view.slot)
		return true
	if select.craft_selected(view.slot):
		select_to_craft(view)
		return true
	return false

func _hold_if_selected(on_release: String, view: Control) -> void:
	if not select.is_selected():
		hold_selection(view)
	else:
		get(on_release).call(view)

func select_to_craft(view: Control) -> void:
	_hold_if_selected("craft_one_item", view)

func moving_items(view: Control) -> void:
	_hold_if_selected("_release_item", view)

func select_item(view: Control) -> void:
	if crafting_items(view): return
	if equiping_items(): return
	moving_items(view)
