extends Node

@onready var timing: Node = $timing
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func setup_items(items: FocusedItems) -> void:
	timing.select.connect(items.set_focus)
	timing.mods.space_trigger.connect(items.set_space)
	for device in [keyboard, gamepad]:
		device.first.connect(items.first)
		device.last.connect(items.last)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		gamepad.set_button(event, self)
	if event is InputEventJoypadMotion:
		gamepad.set_motion(event, self)
	if event is InputEventKey:
		keyboard.set_focus(event, self)
