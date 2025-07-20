extends Node

signal moving(motion: Vector2)

var hero: CharacterBody2D

var _weight: int = 0
var weight: int:
	get: return _weight
	set(value): _weight = max(0, value)

func reset_velocity(motion: Vector2 = Vector2.ZERO) -> void:
	hero.make_velocity(motion)
	set_moving(motion)

func forget_velocity() -> void:
	reset_velocity()
	hero.view.animation.move(Vector2.ZERO)

func set_moving(motion: Vector2) -> void:
	moving.emit(motion)

func travel(motion: Vector2) -> void:
	reset_velocity(hero.logic.stats.decide_travel(weight, motion))
