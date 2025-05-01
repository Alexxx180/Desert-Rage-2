extends Node

@onready var timing: Node = $timing
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func setup_items(items: Node) -> void:
	timing.space_trigger.connect(items.set_space)
	timing.first.connect(items.first)
	timing.last.connect(items.last)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		gamepad.set_button(event, self)
	if event is InputEventJoypadMotion:
		gamepad.set_motion(event, self)
	if event is InputEventKey:
		keyboard.set_focus(event, self)
