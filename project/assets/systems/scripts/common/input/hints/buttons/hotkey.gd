extends Control

@export var keyboard: String = "[]"
@export var gamepad: String = ""

func get_text() -> String:
	if Input.get_connected_joypads().size() > 0:
		return gamepad
	else:
		return keyboard
