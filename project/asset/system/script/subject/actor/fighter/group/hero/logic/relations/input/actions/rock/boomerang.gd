extends Node

func controls(meta: Dictionary) -> void:
	meta.input.board.set_value("boomerang", { "pressed": false, "toggled": false })
