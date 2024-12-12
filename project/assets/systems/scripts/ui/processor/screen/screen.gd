extends Node

@onready var mode: Node = $mode

var hints: HBoxContainer
var state: HBoxContainer
var button: Button

func _toggle(fullscreen: bool) -> void:
	state.set_window_mode(fullscreen)
	hints.set_control_hint()
	mode.toggle(fullscreen)

func _ready() -> void:
	button.button_pressed = mode.is_full()
	_toggle(mode.is_full())

func _input(_event: InputEvent) -> void:
	hints.set_control_hint()
