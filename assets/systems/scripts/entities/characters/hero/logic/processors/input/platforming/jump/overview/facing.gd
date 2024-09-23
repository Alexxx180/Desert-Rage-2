extends RefCounted

class_name Facing

var axis: int = 0
var _hero: CharacterBody2D

func _init(hero: CharacterBody2D) -> void:
	_hero = hero

func subject() -> float:
	return _hero.position[axis]
