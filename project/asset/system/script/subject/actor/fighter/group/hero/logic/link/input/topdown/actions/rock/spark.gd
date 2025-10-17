extends Node

func controls(meta: Dictionary) -> void:
	meta.board.set_value("spark", { "pressed": false, "toggled": false })
