extends Node

var hero: CharacterBody2D
var axis: int = 1
var _weight: int = 0
var weight: int:
	get: return _weight
	set(value): _weight = max(0, value)

func make_velocity(motion: Vector2) -> void:
	hero.make_velocity(motion)
	hero.view.animation.move(motion)

func forget_velocity() -> void:
	make_velocity(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	motion.y *= axis
	make_velocity(hero.logic.stats.decide_travel(weight, motion))
