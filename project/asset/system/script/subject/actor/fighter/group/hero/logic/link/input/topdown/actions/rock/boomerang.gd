extends Node

func controls(meta: Dictionary) -> void:
	meta.board.set_value("boomerang", { "pressed": false, "toggled": false })
