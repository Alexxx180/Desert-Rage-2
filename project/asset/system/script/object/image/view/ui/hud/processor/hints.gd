extends Node

var short: Control

func _input(event: InputEvent) -> void:
	short.sync_control_hint(event)
