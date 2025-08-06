extends Node

func controls(hero: CharacterBody2D, meta: Dictionary) -> void:
	meta.board.set_value("kick", { "pressed": false, "toggled": false })
	return
	"""
	var stomp: Dictionary = {
		"plate": act.skills.act.strike,
		"box": act.skills.act.bash
	}
	board.set_value("stomp", stomp)
	"""
