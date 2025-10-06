extends Node

func controls(meta: Dictionary) -> void:
	meta.actions.board.set_value("cut", { "pressed": false, "toggled": false })
