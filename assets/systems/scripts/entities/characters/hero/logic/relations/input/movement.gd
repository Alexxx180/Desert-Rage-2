extends Node

func set_control(input: Node, hero: CharacterBody2D) -> void:
	var stats: Node = hero.logic.stats
	var face: Node = input.movement.face
	var push: Node = hero.logic.processors.environment.interaction.push

	hero.moving.connect(push.set_velocity)

	input.directing.connect(face.set_direction)
	input.movement.move.connect(hero.travel)
	input.movement.accelerate.connect(stats.accelerate)
