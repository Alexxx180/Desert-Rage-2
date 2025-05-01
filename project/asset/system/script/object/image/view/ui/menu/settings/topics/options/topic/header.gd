extends Button

@onready var topic: VBoxContainer = get_node("../content")

func _toggle_content() -> void:
	topic.visible = !topic.visible
