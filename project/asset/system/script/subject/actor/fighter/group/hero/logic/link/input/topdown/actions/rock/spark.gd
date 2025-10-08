extends Node

func controls(meta: Dictionary) -> void:
	meta.actions.board.set_value("spark", { "pressed": false, "toggled": false })
