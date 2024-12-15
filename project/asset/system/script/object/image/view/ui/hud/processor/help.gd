extends Node

var short: Control
var state: Control

func _input(_event: InputEvent):
	short.set_control_hint()

func show_help(closed: bool) -> void:
	state.toggle(!closed)
	short.set_control_hint()
