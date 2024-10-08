extends Node

signal refresh(stand: Sprite2D, status: bool)

const OFFSET: Vector2 = Vector2(0, 32)

var _id: int = 0

func empty() -> bool: return _id == 0
func stand() -> bool: return _id != 0

func same(hero: CharacterBody2D) -> bool:
	return _id == hero.get_instance_id()

func is_in_midair(hero: CharacterBody2D) -> bool:
	return hero.logic.processors.input.platforming.jump.feet.balance.unstable

func visit(hero: CharacterBody2D, id: int) -> void:
	refresh.emit(hero.view.stand, id != 0)
	_id = id
