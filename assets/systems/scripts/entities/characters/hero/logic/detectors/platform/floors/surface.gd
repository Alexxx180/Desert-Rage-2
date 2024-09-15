extends Node

var jump: Node
var ground: Node
var F: int = 0

func append(surface) -> void:
	ground.at_new_floor(surface)
	if jump.feet.stable: F = ground.F

func remove(surface) -> void:
	ground.at_old_floor(surface)
	if jump.feet.stable: F = ground.F

func set_control_entity(hero: CharacterBody2D) -> void:
	jump = hero.processing.platforming.jump
