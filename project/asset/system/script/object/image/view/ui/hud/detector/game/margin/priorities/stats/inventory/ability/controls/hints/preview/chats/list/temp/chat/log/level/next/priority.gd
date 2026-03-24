extends VBoxContainer

@onready var caption: Label = $caption
@onready var level: Label = $level

var names: Array[String] = ["Стремление", "Выдержка", "Стойкость"]

func set_priority(at: int, lv: int) -> void:
	caption.text = names[at]
	level.text = str(lv)
