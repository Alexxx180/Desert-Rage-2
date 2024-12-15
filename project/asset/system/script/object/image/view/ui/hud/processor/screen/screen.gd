extends Node

@onready var mode: Node = $mode

var short: Control
var state: Control

func update_state(screen: Button) -> void:
	screen.button_pressed = mode.is_full()

func toggle(fullscreen: bool) -> void:
	state.set_window_mode(fullscreen)
	short.set_control_hint()
	mode.toggle(fullscreen)

func _input(_event: InputEvent) -> void:
	short.set_control_hint()
