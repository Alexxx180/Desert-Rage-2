class_name InventorySelect extends Node

enum { MAIN = 0, CRAFT = 25, SPACE = 26 }

var items: Node
var selection: Array[Dictionary] = [_cursor(), _cursor()]
var main: Dictionary:
	get: return selection[MAIN]

func _cursor() -> Dictionary: return { "bag": HUD.NODE, "slot": Def.INT }

func set_selection(bag: Node, slot: int) -> void: main.bag = bag ; main.slot = slot

func craft_selected(slot: int) -> bool: return slot == CRAFT

func is_space() -> bool: return main.slot == SPACE

func is_craft() -> bool: return craft_selected(main.slot)

func is_selected() -> bool: return main.slot != Def.INT

func reset_selection() -> void: set_selection(HUD.NODE, Def.INT)

func from_ui(ui: Control) -> void: from_space(ui.drag, ui.slot)

func from_space(drag: Node, slot: int = SPACE) -> void:
	set_selection(drag.inventory, slot)

func trades_bag(bag: Node, slot: int) -> void:
	bag.logic.items.trade.bags(items, main.slot, slot)

func trades(slot: int) -> void: trades_bag(main.bag, slot)

func release_item(view: Control) -> void:
	trades(view.slot)
	reset_selection()
