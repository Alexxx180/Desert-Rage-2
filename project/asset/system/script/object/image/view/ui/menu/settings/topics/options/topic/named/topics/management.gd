extends VBoxContainer

@onready var mouse: VBoxContainer = $mouse
@onready var keyboard: VBoxContainer = $keyboard
@onready var gamepad: VBoxContainer = $gamepad
@onready var focus: Node = $focus

var focused: bool:
	get: return focus.focused
	set(value): focus.focused = value

func _ready() -> void:
	focus.options = [mouse.get_node("header"), gamepad.get_node("header"),
		keyboard.get_node("header"), keyboard.get_node("header"),
		mouse.options.sensitivity.submit, gamepad.options.get_node("preview")]
