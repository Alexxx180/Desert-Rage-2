extends Node

@onready var mode: Node = $mode

var short: Control
var state: Control

func update_state(screen: Button) -> void:
	screen.button_pressed = mode.is_full()

func toggle(fullscreen: bool) -> void:
	state.toggle(fullscreen)
	short.set_control_hint()
	mode.toggle(fullscreen)

func _input(event: InputEvent) -> void:
	short.sync_control_hint(event)
