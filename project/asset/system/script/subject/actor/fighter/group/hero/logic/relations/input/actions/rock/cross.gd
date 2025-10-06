extends Node

func controls(meta: Dictionary) -> void:
	meta.actions.board.set_value("cross", { "pressed": false, "toggled": false })
