extends Node

const DAMAGE: int = 5

var sided: FightRange = FightRange.new()
var is_near: bool:
	get: return _hero.logic.detectors.world.book.is_colliding()

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	set(value):
		_hero = value

func take_effect() -> void:
	sided.hit(DAMAGE)
