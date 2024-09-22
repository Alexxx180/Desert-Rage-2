extends Node

func set_control(movement: Node, hero: CharacterBody2D) -> void:
	var stats: Node = hero.logic.stats
	movement.move.connect(hero.travel)
	movement.accelerate.connect(stats.accelerate)
	movement.accelerate.emit(movement.WALK)
