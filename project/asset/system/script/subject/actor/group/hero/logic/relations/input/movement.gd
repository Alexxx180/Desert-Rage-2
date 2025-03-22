extends Node

func controls(hero: CharacterBody2D, movement: Node) -> void:
	print("CONNECT MOVEMENT")
	movement.move.connect(hero.travel)
	movement.accelerate.connect(hero.logic.stats.accelerate)
	movement.accelerate.connect(hero.view.animation.set_speed)
