extends Node

func controls(meta: Dictionary) -> void:
	var press: Node = meta.act.skills.press
	# var act: Node = meta.act.skills.act
	# act.book.hero = hero
	# meta.tools.plate = press
	meta.tools.stomp = { "plate": press.stomp, "box": press.throw }
	meta.input.board.set_value("kick", { "pressed": false, "toggled": false })
