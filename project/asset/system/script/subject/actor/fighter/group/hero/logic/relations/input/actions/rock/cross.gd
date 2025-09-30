extends Node

func controls(meta: Dictionary) -> void:
	meta.input.board.set_value("cross", { "pressed": false, "toggled": false })
