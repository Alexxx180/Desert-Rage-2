extends RefCounted

class_name HeroParty

const COUNT: int = 2
var _main: int = 0

func _get_next_hero() -> int:
	return (_main + 1) % COUNT

func reorder() -> Vector2i:
	var next: int = _get_next_hero()
	return Vector2i(_main, next)

func locate(party: Array, position: Vector2) -> Vector2:
	for hero in party:
		hero.position = position
	return Vector2.ZERO

func traverse() -> Vector2i:
	var order: Vector2i = reorder()
	_main = order.y
	return order
