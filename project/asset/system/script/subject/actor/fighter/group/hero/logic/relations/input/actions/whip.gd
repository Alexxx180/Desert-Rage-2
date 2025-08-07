extends Node

func controls(hero: CharacterBody2D, meta: Dictionary) -> void:
	meta.input.board.set_value("whip", { "pressed": false, "toggled": false })
