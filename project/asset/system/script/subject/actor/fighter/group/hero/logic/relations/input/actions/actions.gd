extends Node

func controls(hero: CharacterBody2D, input: Node) -> void:
	var meta: Dictionary = { "tools": { "hero": hero }, "combo": {},
		"actions": input.topdown.actions, # "input": input,
		"act": hero.logic.work.world, "ui": hero.logic.work.stats.hud }

	for skill in get_children(): skill.controls(meta)

	for key in ["tools", "combo", "ui"]:
		meta.actions.board.set_value(key, meta[key])
