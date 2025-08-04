extends Node

func controls(hero: CharacterBody2D, board: BehaviorBlackboard, act: Node) -> void:
	var strike: Dictionary = {
		"lever": act.skills.act.strike,
		"book": act.skills.act.bash
	}
	board.set_value("lever", act.skills.act)
	board.set_value("strike", strike)
