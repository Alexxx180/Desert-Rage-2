extends Node

func controls(meta: Dictionary) -> void:
	meta.input.board.set_value("knife", { "pressed": false, "toggled": false })
