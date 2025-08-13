extends Node

func controls(hero: CharacterBody2D, meta: Dictionary) -> void:
	if not "whip" in meta.act.ability: return
	var act: Node = meta.act.ability.whip
	meta.tools.hero = hero
	meta.tools.pillar = act
	# meta.tools.strike = { "lever": act.lever, "book": act.book }

	meta.input.board.set_value("whip", { "pressed": false, "toggled": false })
