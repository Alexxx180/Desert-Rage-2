extends HBoxContainer

@onready var priority: Label = $priority
@onready var level: Label = $level

var priorities: Array[String] = ["Стремление", "Выдержка", "Стойкость"]

func set_priority(no: int, at: int) -> void:
	priority.text = priorities[no]
	level.text = str(at)
