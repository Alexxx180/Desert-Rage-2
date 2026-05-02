extends Node

func controls(hero: CharacterBody2D, topdown: Node) -> void:
	var meta: Dictionary = { "tools": { "hero": hero, "combos": null },
		"combo": {},
		"board": topdown.actions.board,
		"actions": topdown.actions, "act": hero.to.world, "ui": hero.to.hud }

	for skill in get_children(): skill.controls(meta)

	for key in ["tools", "combo", "ui"]:
		meta.board.s(key, meta[key]); print("hero: ", hero)

func controls_punch(meta: Dictionary) -> void:
	var act: Node = meta.act.skills.act
	act.book.hero = meta.tools.hero
	meta.tools.lever = act
	meta.tools.strike = { "lever": act.lever, "book": act.book }
	meta.board.s("punch", { "pressed": false, "toggled": false })
	print("PUNCH SET: ", meta.board)

func controls_kick(meta: Dictionary) -> void:
	var press: Node = meta.act.skills.press
	meta.tools.stomp = { "plate": press, "box": press } # TODO FIXME unify stomp logic
	meta.board.s("kick", { "pressed": false, "toggled": false })

func controls_rain(meta: Dictionary) -> void:
	meta.board.s("rain", { "pressed": false, "toggled": false })

func controls_spark(meta: Dictionary) -> void:
	meta.board.s("spark", { "pressed": false, "toggled": false })

func controls_cut(meta: Dictionary) -> void:
	meta.board.s("cut", { "pressed": false, "toggled": false })

func controls_cross(meta: Dictionary) -> void:
	meta.board.s("cross", { "pressed": false, "toggled": false })

func controls_boomerang(meta: Dictionary) -> void:
	meta.board.s("boomerang", { "pressed": false, "toggled": false })

func controls_combo(meta: Dictionary) -> void:
	meta.combo.timer = meta.actions.timer# .combo
	meta.combo.query = []
	meta.combo.max = 3
