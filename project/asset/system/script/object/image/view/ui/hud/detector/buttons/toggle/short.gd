extends Control

@onready var keyboard: MarginContainer = $keyboard
@onready var gamepad: MarginContainer = $gamepad

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func _set_hint_visible(button: bool) -> void:
	gamepad.visible = button
	keyboard.visible = !button

func set_control_hint() -> void:
	_set_hint_visible(is_gamepad_connected())

func sync_control_hint(event: InputEvent) -> void:
	_set_hint_visible(event is InputEventJoypadButton or event is InputEventJoypadMotion)
