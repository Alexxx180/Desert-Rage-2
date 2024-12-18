extends Node

var short: Array[Control] = []
var state: Control

func _input(event: InputEvent):
	for hint in short:
		hint.sync_control_hint(event)

func show_help(closed: bool) -> void:
	state.toggle(!closed)
	#short.set_control_hint()
