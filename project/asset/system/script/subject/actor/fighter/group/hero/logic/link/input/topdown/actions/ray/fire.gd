extends Node

func controls(meta: Dictionary) -> void:
	meta.board.s("fire", { "pressed": false, "toggled": false })
