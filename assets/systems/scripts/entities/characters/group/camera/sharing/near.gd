extends Area2D

signal deploy(can: bool)

var _count: int = 0

func ready_to_deploy(_hero: CharacterBody2D) -> void:
	_count += 1
	deploy.emit(_count == HeroParty.COUNT)

func hero_get_far_away(_hero: CharacterBody2D) -> void:
	_count -= 1
	deploy.emit(_count == HeroParty.COUNT)
