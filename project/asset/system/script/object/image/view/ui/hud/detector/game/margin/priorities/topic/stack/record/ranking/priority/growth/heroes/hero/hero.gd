extends TextureRect

@onready var priority: VBoxContainer = $back/priority

func change(prev: int, at: int) -> void:
	priority.priorities[prev].hide()
	priority.priorities[at].show()
