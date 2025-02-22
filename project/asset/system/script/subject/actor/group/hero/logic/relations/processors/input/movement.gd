extends Node

func controls(hero: CharacterBody2D, movement: Node) -> void:
	var stats: EntityStats = hero.logic.stats

	movement.move.connect(hero.travel)
#	movement.move.connect(hero.logic.processors.environment.interaction.pull.set_velocity)
	movement.accelerate.connect(stats.accelerate)
