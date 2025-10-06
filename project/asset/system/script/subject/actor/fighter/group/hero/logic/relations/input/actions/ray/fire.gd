extends Node

func controls(meta: Dictionary) -> void:
	meta.actions.board.set_value("fire", { "pressed": false, "toggled": false })
