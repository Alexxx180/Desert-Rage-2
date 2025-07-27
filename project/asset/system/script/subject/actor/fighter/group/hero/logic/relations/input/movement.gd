extends Node

func controls(hero: CharacterBody2D, movement: Node) -> void:
	print("CONNECT MOVEMENT")
	hero.logic.processors.ui.input.gravity.hero = hero
	movement.hero = hero
	movement.behavior.move.move.connect(hero.logic.processors.ui.input.movement.type.velocity.travel)
	movement.behavior.run.accelerate.connect(hero.logic.stats.accelerate)
	movement.behavior.run.accelerate.connect(hero.view.animation.moves.set_walk_speed)
