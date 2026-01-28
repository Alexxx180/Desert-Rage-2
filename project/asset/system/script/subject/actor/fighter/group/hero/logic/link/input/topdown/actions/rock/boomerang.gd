extends Node

func controls(meta: Dictionary) -> void:
	meta.board.s("boomerang", { "pressed": false, "toggled": false })
