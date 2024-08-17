extends Node

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	get:
		return _hero
	set(entity):
		_hero = entity
		has_hero = true

var has_hero: bool = false
var previous: Vector2

func set_floor(F: int):
	if has_hero:
		hero.detectors.platform.floors.surface.F = F

func remember() -> void:
	if has_hero: 
		previous = hero.position

func rollback() -> void:
	if has_hero:
		hero.position = previous

func move(axis: int, velocity: float) -> void:
	if has_hero:
		hero.position[axis] += velocity
