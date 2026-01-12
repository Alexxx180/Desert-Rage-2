extends MarginContainer

@onready var title: HBoxContainer = $short/title
@onready var caption: Label = $short/margin/caption
@onready var effect: Label = $effect
#@onready var effects: HBoxContainer = $short/effects

func set_item(item: Dictionary) -> void:
	title.set_item(item) #effects.set_effect(item.logic)
	effect.text = item.item.description
	caption.text = item.item.name

func helping() -> void:
	title.effects.hide()
	caption.text = "Инвентарь, ЛКМ"
	title.effect.text = "Область для осмотра"
