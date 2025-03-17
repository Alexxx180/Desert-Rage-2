extends Node

var hero: CharacterBody2D

func start_forward(box: CharacterBody2D) -> void:
	box.logic.processors.grab_box(hero)
	hero.weight += box.weight

func stop_forward(box: CharacterBody2D) -> void:
	box.logic.processors.release_box(hero)
	hero.weight -= box.weight
