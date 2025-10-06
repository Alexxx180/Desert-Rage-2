extends Node

func controls(meta: Dictionary) -> void:
	meta.actions.board.set_value("knife", { "pressed": false, "toggled": false })
