extends Node

func controls(meta: Dictionary) -> void:
	meta.board.set_value("knife", { "pressed": false, "toggled": false })
