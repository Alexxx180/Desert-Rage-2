extends Button

class_name InventoryItem

@onready var margin: MarginContainer = $margin

const MAIN: int = 0

var selection: Array[Dictionary]

func _ready() -> void: pressed.connect(select_item)

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

func select_item() -> void:
	if selection[MAIN].bag == Defaults.NODE:
		margin.view.hold_item(selection[MAIN])
	else:
		_release_item()
