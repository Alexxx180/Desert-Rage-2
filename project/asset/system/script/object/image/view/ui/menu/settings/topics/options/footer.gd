extends Button

@onready var topic: VBoxContainer = get_parent()

func _hide_topic() -> void: topic.hide()
