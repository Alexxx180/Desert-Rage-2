extends Button

class_name InventoryItem

@onready var margin: MarginContainer = $margin

func _ready() -> void: pressed.connect(select_item)

func select_item() -> void:
	margin.view.drag.craft.selection.select_item(margin.view)

func remove_item() -> void: margin.remove_item()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	margin.replace_item(next, prev)

func put_item(slot: Dictionary) -> void: margin.put_item(slot)
