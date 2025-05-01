extends Button

@onready var topic: VBoxContainer = get_parent()
@onready var header: Button = topic.get_node("../header")

func _hide_topic() -> void:
	topic.hide()
	header.grab_focus()
