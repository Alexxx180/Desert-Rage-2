extends Area2D

signal is_near(can_is_near: bool)

var _count: int = 0

func ready_to_deploy(hero: PhysicsBody2D) -> void:
	if not hero.is_in_group("enemy"):
		_count += 1
		is_near.emit(_count == HeroParty.COUNT)

func hero_get_far_away(hero: PhysicsBody2D) -> void:
	if not hero.is_in_group("enemy"):
		_count -= 1
		is_near.emit(_count == HeroParty.COUNT)
