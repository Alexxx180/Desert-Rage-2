extends Node

signal standing(stand: Sprite2D)
signal leaving(stand: Sprite2D)

var _hero_id: int = 0

func empty() -> bool: return _hero_id == 0
func stand() -> bool: return _hero_id != 0

func stay(box: Sprite2D) -> void:
	standing.emit(box)

func leave() -> void:
	leaving.emit()

func same(hero: CharacterBody2D) -> bool:
	return _hero_id == hero.get_instance_id()

func is_in_midair(hero: CharacterBody2D) -> bool:
	return hero.logic.processors.input.platforming.jump.feet.balance.unstable

func visit(hero: CharacterBody2D, id: int) -> void:
	hero.view.stand.visible = is_in_midair(hero)
	_hero_id = id
