extends Button

class_name InventoryItem

@onready var margin: MarginContainer = $margin

enum { MAIN = 0, CRAFT = 26 }

var selection: Array[Dictionary]

func _ready() -> void: pressed.connect(select_item)
func is_selected() -> bool: return selection[MAIN].bag != Defaults.NODE

func remove_item() -> void: margin.remove_item()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	margin.replace_item(next, prev)

func put_item(slot: Dictionary) -> void: margin.put_item(slot)

func reset_selection() -> void:
	selection[MAIN].bag = Defaults.NODE
	selection[MAIN].slot = Defaults.INT

func _release_item() -> void:
	margin.view.trade(selection[MAIN].bag.logic, selection[MAIN].slot)
	reset_selection()

func craft_all_items() -> void: pass

func craft_more_items() -> void:
	margin.view.inventory.trade.craft.one_slot(selection[MAIN])

func hold_selection() -> void:
	margin.view.hold_item(selection[MAIN])

func craft_one_item() -> void:
	margin.view.inventory.trade.craft.one_item(selection[MAIN])

func select_to_craft() -> void:
	if not is_selected():
		hold_selection()
	else:
		craft_one_item()

func equiping_items() -> bool: return false

func crafting_items() -> bool:
	if selection[MAIN].slot == CRAFT:
		craft_more_items()
		return true
	if margin.view.slot == CRAFT:
		select_to_craft()
		return true
	return false

func moving_items() -> void:
	if not is_selected():
		hold_selection()
	else:
		_release_item()

func select_item() -> void:
	if crafting_items(): return
	if equiping_items(): return
	moving_items()
