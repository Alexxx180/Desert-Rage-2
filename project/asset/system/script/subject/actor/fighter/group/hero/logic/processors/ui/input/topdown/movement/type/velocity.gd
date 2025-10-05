extends Node

var hero: CharacterBody2D
var _weight: int = 0
var weight: int:
	get: return _weight
	set(value): _weight = max(0, value)
var axis: int = 1

func make(motion: Vector2) -> void:
	hero.make_velocity(motion)
	hero.view.animation.move(motion)

func forget() -> void:
	make(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion.y *= axis
	make(hero.logic.stats.decide_travel(weight, motion))
