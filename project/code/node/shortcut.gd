extends Node

class_name InputShortcut

signal feedback()

@export var action: String = "fire"
@export var parenting: String = ".."

func _ready() -> void:
	feedback.connect(get_node(parenting).feedback)

func corresponds(event: InputEvent) -> bool:
	return Input.is_action_just_pressed(action) and event is not InputEventMouseButton

func _input(event: InputEvent) -> void:
	if corresponds(event): feedback.emit()
