extends Area2D

signal is_near(can_is_near: bool)

var _count: int = 0

func ready_to_deploy(_hero: CharacterBody2D) -> void:
	_count += 1
	is_near.emit(_count == HeroDeploy.COUNT)

func hero_get_far_away(_hero: CharacterBody2D) -> void:
	_count -= 1
	is_near.emit(_count == HeroDeploy.COUNT)
