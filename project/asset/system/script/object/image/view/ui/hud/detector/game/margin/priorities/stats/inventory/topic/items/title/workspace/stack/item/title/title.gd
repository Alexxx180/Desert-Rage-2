extends HBoxContainer

@onready var effect: Label = $effect
@onready var effects: HBoxContainer = $effects

func set_item(item: Dictionary) -> void:
	effect.text = item.item.short
	effects.set_effect(item.logic)
