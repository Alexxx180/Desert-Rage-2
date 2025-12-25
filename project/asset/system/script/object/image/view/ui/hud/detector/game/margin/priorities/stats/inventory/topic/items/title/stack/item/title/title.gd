extends HBoxContainer

@onready var caption: Label = $caption
@onready var effects: HBoxContainer = $effects

func set_item(item: Dictionary) -> void:
	caption.text = item.item.title
	effects.set_effect(item.logic)
