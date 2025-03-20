extends Node

const GAP: int = 32

func _between(ledge: float, subject: float) -> bool:
	return subject >= ledge - GAP and subject <= ledge + GAP

func _more(x: float, y: float) -> bool: return x > y
func _less(x: float, y: float) -> bool: return x < y

func _side(hero: CharacterBody2D, axis: int, align: Callable) -> Callable:
	return func(ledge: Vector2) -> bool:
		return align.call(ledge[axis], hero.position[axis])

func decide(hero: CharacterBody2D, axis: int) -> Array[Callable]:
	return [
		_side(hero, axis, _between),
		_side(hero, axis, _more),
		_side(hero, axis, _less)
	]
