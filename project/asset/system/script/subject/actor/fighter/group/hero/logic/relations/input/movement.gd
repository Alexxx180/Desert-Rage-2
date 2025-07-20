extends Node

func controls(hero: CharacterBody2D, movement: Node) -> void:
	print("CONNECT MOVEMENT")
	hero.logic.processors.ui.input.gravity.hero = hero
	movement.mode.hero = hero
	movement.move.connect(hero.logic.processors.ui.input.movement.mode.velocity.travel)
	movement.accelerate.connect(hero.logic.stats.accelerate)
	movement.accelerate.connect(hero.view.animation.moves.set_walk_speed)
