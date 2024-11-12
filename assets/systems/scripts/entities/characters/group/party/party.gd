extends RefCounted

class_name HeroParty

const COUNT: int = 2
var _main: int = 0
var main: int:
	get: return _main

func _get_next_hero() -> int:
	return (_main + 1) % COUNT

func reorder() -> Vector2i:
	var next: int = _get_next_hero()
	return Vector2i(_main, next)

func locate(party: Array, position: Vector2) -> Vector2:
	for hero in party:
		hero.position = position
	return Vector2.ZERO

func traverse(order: Vector2i) -> Vector2i:
	_main = order.y
	return order
