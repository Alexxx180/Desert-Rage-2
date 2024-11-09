extends Node

signal standing(seat: Node, hero: CharacterBody2D)
signal leaving(seat: Node, hero: CharacterBody2D)

var _hero_id: int = 0

func empty() -> bool: return _hero_id == 0
func stand() -> bool: return _hero_id != 0

func stay(seat: Node, hero: CharacterBody2D) -> void:
	standing.emit(seat, hero)

func leave(seat: Node, hero: CharacterBody2D) -> void:
	leaving.emit(seat, hero)

func same(hero: CharacterBody2D) -> bool:
	return _hero_id == hero.get_instance_id()

func is_in_midair(hero: CharacterBody2D) -> bool:
	return hero.logic.processors.input.platforming.jump.feet.balance.unstable

func visit(hero: CharacterBody2D, id: int) -> void:
	hero.view.visible = !is_in_midair(hero)
	_hero_id = id
