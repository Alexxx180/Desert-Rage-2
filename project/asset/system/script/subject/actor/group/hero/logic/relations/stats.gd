extends Node

func controls(hero: CharacterBody2D, stats: EntityStats) -> void:
	var processors: Node = hero.logic.processors
	var pull: Node = processors.environment.interaction.pull

	stats.new_mach.connect(hero.view.animation.set_speed)

	#stats.size.set_control_entity(hero)
	stats.run.connect(processors.input.movement.feet.set_velocity)
	stats.run.emit(stats.speed * stats.STEP)
	stats.impulse.connect(pull.set_impulse)
	stats.apply_impulse(1)
