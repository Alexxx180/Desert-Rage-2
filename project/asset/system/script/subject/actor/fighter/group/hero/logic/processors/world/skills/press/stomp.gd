extends Node

const DAMAGE: int = 5

var box: Area2D:
	get: return _hero.logic.detectors.

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	set(value):
		_hero = value

func take_effect() -> void:
	after_tile.hit(DAMAGE)
	# box logic
