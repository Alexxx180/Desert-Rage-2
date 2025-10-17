extends Node

func controls(meta: Dictionary) -> void:
	var act: Node = meta.act.skills.act
	act.book.hero = meta.tools.hero
	meta.tools.lever = act
	meta.tools.strike = { "lever": act.lever, "book": act.book }
	meta.board.set_value("punch", { "pressed": false, "toggled": false })
	print("PUNCH SET: ", meta.board)
