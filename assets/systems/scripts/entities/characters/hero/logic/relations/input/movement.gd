extends Node

func set_control(input: Node, hero: CharacterBody2D) -> void:
	var stats: Node = hero.logic.stats
	var face: Node = input.movement.face

	input.directing.connect(face.set_direction)
	input.movement.move.connect(hero.travel)
	input.movement.accelerate.connect(stats.accelerate)
