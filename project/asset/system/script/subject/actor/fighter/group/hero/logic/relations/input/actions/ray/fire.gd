extends Node

func controls(meta: Dictionary) -> void:
	meta.input.board.set_value("fire", { "pressed": false, "toggled": false })
