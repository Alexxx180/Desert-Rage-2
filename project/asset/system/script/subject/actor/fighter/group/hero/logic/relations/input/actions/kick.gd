extends Node

func controls(hero: CharacterBody2D, meta: Dictionary) -> void:
	var press: Node = meta.act.skills.press
	# var act: Node = meta.act.skills.act
	# act.book.hero = hero
	# meta.tools.plate = press
	meta.tools.hero = hero
	meta.tools.stomp = { "plate": press.stomp, "box": press.throw }
	meta.input.board.set_value("kick", { "pressed": false, "toggled": false })
