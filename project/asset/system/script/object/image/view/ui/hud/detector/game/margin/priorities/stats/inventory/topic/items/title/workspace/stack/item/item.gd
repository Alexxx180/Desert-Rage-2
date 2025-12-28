extends MarginContainer

@onready var title: HBoxContainer = $short/margin/title
@onready var effect: Label = $short/effect

func set_item(item: Dictionary) -> void:
	title.set_item(item)
	effect.text = item.item.short

func helping() -> void:
	title.effects.hide()
	title.caption.text = "Инвентарь, ЛКМ"
	effect.text = "Область осмотра предметов" # Предмет - все, Пусто - 1
