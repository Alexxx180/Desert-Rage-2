extends Node

func controls(meta: Dictionary) -> void:
	meta.board.set_value("cut", { "pressed": false, "toggled": false })
