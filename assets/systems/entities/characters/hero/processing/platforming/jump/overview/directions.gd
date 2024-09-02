extends Node

const GAP: int = 24

var _plane: Array[Array]

func init(hero: CharacterBody2D):
	_plane = []
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		_plane.push_back(_compare(axis, hero))

func observe(axis: int, direction: Vector2i, ledge: Vector2) -> bool:
	var faced: int = direction[axis]
	return _plane[axis][faced].call(ledge)

func _inplace(ledge: float, subject: float) -> bool:
	return subject >= ledge - GAP and subject <= ledge + GAP

func _compare(axis: int, hero: CharacterBody2D) -> Array[Callable]:
	return [
		(func(ledge: Vector2): return _inplace(ledge[axis], hero.position[axis])),
		(func(ledge: Vector2): return ledge[axis] > hero.position[axis]),
		(func(ledge: Vector2): return ledge[axis] < hero.position[axis])
	]
