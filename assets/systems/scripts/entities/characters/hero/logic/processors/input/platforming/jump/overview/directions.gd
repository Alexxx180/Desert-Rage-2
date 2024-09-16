extends RefCounted

class_name OverviewDirections

const GAP: int = 24

var _plane: Array[Array] = []

func _init(hero: CharacterBody2D):
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		_plane.push_back(_compare(axis, hero))

func observe(axis: int, direction: Vector2i, ledge: Vector2) -> bool:
	var faced: int = direction[axis]
	return _plane[axis][faced].call(ledge)

func _inplace(ledge: float, subject: float) -> bool:
	return subject >= ledge - GAP and subject <= ledge + GAP

func _check(axis: int, hero: CharacterBody2D, align: Callable) -> Callable:
	return (func(ledge: Vector2): align.call(ledge[axis], hero.position[axis]))

func _compare(axis: int, hero: CharacterBody2D) -> Array[Callable]:
	return [
		_check(axis, hero, _inplace),
		_check(axis, hero, func(x, y): return x > y),
		_check(axis, hero, func(x, y): return x < y)
	]
