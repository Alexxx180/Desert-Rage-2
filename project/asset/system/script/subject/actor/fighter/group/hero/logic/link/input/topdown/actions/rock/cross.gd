extends Node

func controls(meta: Dictionary) -> void:
	meta.board.s("cross", { "pressed": false, "toggled": false })
