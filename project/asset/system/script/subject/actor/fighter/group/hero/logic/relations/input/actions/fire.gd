extends Node

func controls(hero: CharacterBody2D, meta: Dictionary) -> void:
	meta.input.board.set_value("fire", { "pressed": false, "toggled": false })
