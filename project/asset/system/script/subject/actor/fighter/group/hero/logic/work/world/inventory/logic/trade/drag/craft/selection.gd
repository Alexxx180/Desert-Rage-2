extends Node

var select: Node
var craft: Node
var drag: Node

func _release_item() -> void:
	drag.trade(select.main.bag.logic, select.main.slot)
	select.reset_selection()

func craft_all_items() -> void: pass

func craft_more_items() -> void: craft.one_slot(select.main)

func hold_selection() -> void: pass # margin.view.hold_item(select.main)

func craft_one_item() -> void: craft.one_item(select.main)

func equiping_items() -> bool: return false

func crafting_items(slot: int) -> bool:
	if select.was_selected():
		craft_more_items()
		return true
	if select.craft_selected(slot):
		select_to_craft()
		return true
	return false

func _hold_if_selected(on_release: String) -> void:
	if not select.is_selected():
		hold_selection()
	else:
		get(on_release).call()

func select_to_craft() -> void: _hold_if_selected("craft_one_item")

func moving_items() -> void: _hold_if_selected("_release_item")

func select_item(slot: int) -> void:
	if crafting_items(slot): return
	if equiping_items(): return
	moving_items()
