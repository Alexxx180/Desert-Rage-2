extends Node

func controls(meta: Dictionary) -> void:
	meta.input.board.set_value("cut", { "pressed": false, "toggled": false })
