extends Node

func set_control(hero: CharacterBody2D, overview: Node) -> void:
	overview.directions.set_directions(hero)
