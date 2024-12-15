extends Control

@export var keyboard: String = "[]"
@export var gamepad: String = ""

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func get_text() -> String:
	if is_gamepad_connected():
		return gamepad
	else:
		return keyboard
