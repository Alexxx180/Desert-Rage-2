extends RefCounted

class_name Facing

var _axis: int = 0
var axis: int:
	get: return _axis

var _hero: CharacterBody2D

var subject: float:
	get:
		#print("HERO AXIS: ", _axis)
		return _hero.position[_axis]

func _init(hero: CharacterBody2D, dir_axis: int) -> void:
	_hero = hero
	_axis = dir_axis
