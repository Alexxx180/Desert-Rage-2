extends Node

var platforming: Node
var ground: Node
var F: int = 0

func append(surface: StaticBody2D) -> void:
	ground.at_new_floor(surface)
	if platforming.on_floor: F = ground.F

func remove(surface: StaticBody2D) -> void:
	ground.at_old_floor(surface)
	if platforming.on_floor: F = ground.F

func set_control_entity(hero: CharacterBody2D) -> void:
	platforming = hero.detectors.platform.ledge.platforming
