extends Node

class_name InventorySelect

enum { MAIN = 0, CRAFT = 25 }

var items: Node
var selection: Array[Dictionary] = [_cursor(), _cursor()]
var main: Dictionary:
	get: return selection[MAIN]

func _cursor() -> Dictionary: return { "bag": Defaults.NODE, "slot": Defaults.INT }

func set_selection(bag: Node, slot: int) -> void: main.bag = bag ; main.slot = slot

func craft_selected(slot: int) -> bool: return slot == CRAFT

func was_selected() -> bool: return craft_selected(main.slot)

func is_selected() -> bool: return main.slot != Defaults.INT

func reset_selection() -> void: set_selection(Defaults.NODE, Defaults.INT)

func from_ui(ui: Control) -> void: set_selection(ui.drag.inventory, ui.slot)

func trades(slot: int) -> void:
	main.bag.logic.trade.bags(items, main.slot, slot)

func release_item(view: Control) -> void:
	trades(view.slot)
	reset_selection()
