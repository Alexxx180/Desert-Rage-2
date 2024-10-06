extends RefCounted

class_name Facing

var axis: int = 0
var _hero: CharacterBody2D

var subject: float:
	get: return _hero.position[axis]

func _init(hero: CharacterBody2D) -> void:
	_hero = hero
