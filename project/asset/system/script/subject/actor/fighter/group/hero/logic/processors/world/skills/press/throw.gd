extends Node

const POWER: int = 10

var pull: Node:
	get: return _hero.logic.processors.world.skills.pull
var is_near: bool:
	get: return pull.boxes.size() > 0

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	set(value):
		_hero = value

func take_effect() -> void:
	for box in pull.boxes:
		box.logic.processors.movement.push.throw_velocity(POWER)
