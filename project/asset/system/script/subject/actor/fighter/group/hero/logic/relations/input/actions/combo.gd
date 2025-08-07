extends Node

func controls(hero: CharacterBody2D, meta: Dictionary) -> void:
	meta.combo.timer = meta.input.combo
	meta.combo.query = []
	meta.combo.max = 3
