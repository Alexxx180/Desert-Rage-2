extends Node

func controls(hero: CharacterBody2D, movement: Node) -> void:
	var stats: Node = hero.logic.stats

	movement.move.connect(hero.travel)
	movement.accelerate.connect(stats.accelerate)
