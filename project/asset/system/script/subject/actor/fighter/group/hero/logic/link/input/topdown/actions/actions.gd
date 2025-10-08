extends Node

func controls(hero: CharacterBody2D, topdown: Node) -> void:
	var meta: Dictionary = { "tools": { "hero": hero }, "combo": {},
		"actions": topdown.actions, "act": hero.to.world, "ui": hero.to.hud }

	for skill in get_children(): skill.controls(meta)

	for key in ["tools", "combo", "ui"]:
		meta.actions.board.set_value(key, meta[key])
