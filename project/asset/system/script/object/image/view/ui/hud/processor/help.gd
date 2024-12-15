extends Node

var short: Control
var state: Control

func _input(event: InputEvent):
	short.sync_control_hint(event)

func show_help(closed: bool) -> void:
	state.toggle(!closed)
	#short.set_control_hint()
