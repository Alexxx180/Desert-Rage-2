extends MarginContainer

@onready var items: HBoxContainer = $short/margin/items
@onready var effect: Label = $short/effect

func set_item(item: Dictionary) -> void:
	items.set_item(item)
	effect.text = item.item.short
