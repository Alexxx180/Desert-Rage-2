extends Node

func controls(meta: Dictionary) -> void:
	meta.board.set_value("rain", { "pressed": false, "toggled": false })
