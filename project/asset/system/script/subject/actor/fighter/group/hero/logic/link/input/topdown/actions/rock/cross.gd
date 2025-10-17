extends Node

func controls(meta: Dictionary) -> void:
	meta.board.set_value("cross", { "pressed": false, "toggled": false })
