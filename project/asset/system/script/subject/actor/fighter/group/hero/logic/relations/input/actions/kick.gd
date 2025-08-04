extends Node

func controls(hero: CharacterBody2D, board: BehaviorBlackboard, act: Node) -> void:
	var stomp: Dictionary = {
		"plate": act.skills.act.strike,
		"box": act.skills.act.bash
	}
	board.set_value("stomp", stomp)
