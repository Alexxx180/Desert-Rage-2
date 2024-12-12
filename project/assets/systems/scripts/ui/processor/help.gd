extends Node

var hints: HBoxContainer
var state: HBoxContainer

func _ready() -> void:
	_on_help_show(true)

func _input(_event: InputEvent):
	hints.set_control_hint()

func _on_help_show(closed: bool) -> void:
	state.set_state(!closed)
	hints.set_control_hint()
