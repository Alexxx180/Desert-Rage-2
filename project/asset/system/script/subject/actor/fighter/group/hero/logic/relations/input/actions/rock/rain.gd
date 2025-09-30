extends Node

func controls(meta: Dictionary) -> void:
	meta.input.board.set_value("rain", { "pressed": false, "toggled": false })
