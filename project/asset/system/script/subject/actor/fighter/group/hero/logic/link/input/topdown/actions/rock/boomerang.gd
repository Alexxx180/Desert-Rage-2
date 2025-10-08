extends Node

func controls(meta: Dictionary) -> void:
	meta.actions.board.set_value("boomerang", { "pressed": false, "toggled": false })
