extends Node

enum { MAIN = 0, CRAFT = 26 }

var items: Node
var selection: Array[Dictionary]
var main: Dictionary:
	get: return selection[MAIN]

func was_selected() -> bool: return main.slot == CRAFT

func is_selected() -> bool: return main.bag != Defaults.NODE

func set_selection(bag: Node, slot: int) -> void:
	main.bag = bag ; main.slot = slot

func reset_selection() -> void: set_selection(Defaults.NODE, Defaults.INT)

func from_ui(ui: Control) -> void: set_selection(ui.inventory, ui.slot)

func trades(slot: int) -> void:
	main.bag.logic.trade.bags(items, main.slot, slot)

func release_item(view: Control) -> void:
	trades(view.slot)
	reset_selection()
