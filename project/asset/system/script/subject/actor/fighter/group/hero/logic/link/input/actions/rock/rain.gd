extends Node

func controls(meta: Dictionary) -> void:
	meta.actions.board.set_value("rain", { "pressed": false, "toggled": false })
