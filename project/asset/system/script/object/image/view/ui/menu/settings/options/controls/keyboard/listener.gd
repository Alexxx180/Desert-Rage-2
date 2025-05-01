extends Node

@export var action: String = "forward"

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		InputMap.action_add_event(action, event.keycode)
