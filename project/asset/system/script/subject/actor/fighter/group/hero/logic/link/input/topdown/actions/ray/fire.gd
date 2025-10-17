extends Node

func controls(meta: Dictionary) -> void:
	meta.board.set_value("fire", { "pressed": false, "toggled": false })
