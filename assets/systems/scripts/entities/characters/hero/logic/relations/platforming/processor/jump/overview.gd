extends Node

func set_control(hero: CharacterBody2D, processor: Node) -> void:
	processor.directions.set_directions(hero)
