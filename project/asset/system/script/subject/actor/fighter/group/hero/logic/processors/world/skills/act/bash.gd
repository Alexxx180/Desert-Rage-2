extends Node

const DAMAGE: int = 5

var is_near: bool = false
var sided: FightRange = FightRange.new()

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	set(value):
		_hero = value

func take_effect() -> void:
	sided.hit(DAMAGE)
