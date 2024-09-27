extends Node

func set_control(hero: CharacterBody2D, processor: Node) -> void:
	var input: Node = hero.logic.processors.input
	var directions: Node = processor.direction

	input.directing.connect(directions.overview.set_direction)
	directions.set_directions(hero)
