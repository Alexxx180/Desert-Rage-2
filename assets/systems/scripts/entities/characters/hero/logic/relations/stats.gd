extends Node

func set_control(hero: CharacterBody2D, stats: Node) -> void:
	var feet: Node = hero.logic.processors.input.movement.feet
	stats.run.connect(feet.set_velocity)
	stats.run.emit(stats.speed.value)
	stats.size.set_control_entity(hero)
