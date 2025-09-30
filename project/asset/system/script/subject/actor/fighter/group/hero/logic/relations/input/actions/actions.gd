extends Node

func controls(hero: CharacterBody2D, input: Node) -> void:
	var act: Node = hero.logic.processors.world
	var meta: Dictionary = { "tools": { "hero": hero }, "combo": {},
		"input": input, "act": act, "ui": hero.logic.processors.ui.hud }

	for skill in get_children(): skill.controls(meta)

	for key in ["tools", "combo", "ui"]:
		input.board.set_value(key, meta[key])
	
	input.combo.timeout.connect(input.reset_combo)
