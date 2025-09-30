extends Node

func controls(meta: Dictionary) -> void:
	meta.input.board.set_value("spark", { "pressed": false, "toggled": false })
