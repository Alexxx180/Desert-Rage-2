extends Node

# signal apply_velocity(velocity: Vector2)

var hero: CharacterBody2D

#const FRICTION: float = 0.01

func start_forward(box: CharacterBody2D) -> void:
	box.logic.processors.grab_box(hero)
	hero.weight += box.weight

func stop_forward(box: CharacterBody2D) -> void:
	box.logic.processors.release_box(hero)
	hero.weight -= box.weight
