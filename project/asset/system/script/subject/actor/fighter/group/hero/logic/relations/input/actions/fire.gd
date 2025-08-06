extends Node

func controls(hero: CharacterBody2D, meta: Dictionary) -> void:
	meta.board.set_value("fire", { "pressed": false, "toggled": false })
