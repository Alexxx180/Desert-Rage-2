extends Node

const GAP: int = 24

var hero: CharacterBody2D
var directions: Array[Array] = [
	regulation(Vector2.AXIS_X), regulation(Vector2.AXIS_Y)
]

func inplace(ledge: float, subject: float) -> bool:
	# return ledge >= subject - GAP and ledge <= subject + GAP
	return subject >= ledge - GAP and subject <= ledge + GAP

func regulation(axis: int) -> Array[Callable]:
	return [
		(func(ledge: Vector2):
			print("DOWN: ", inplace(ledge[axis], hero.position[axis]))
			return inplace(ledge[axis], hero.position[axis])),
		(func(ledge: Vector2): return ledge[axis] > hero.position[axis]),
		(func(ledge: Vector2): return ledge[axis] < hero.position[axis])
	]

func _observe_at(axis: int, direction: Vector2i, ledge: Vector2) -> bool:
	var power: int = direction[axis]
	return directions[axis][power].call(ledge)

func observe(direction: Vector2i, ledge: Vector2) -> bool:
	var jump: bool = true
	var plane: Array[int] = [Vector2.AXIS_X, Vector2.AXIS_Y]
	for axis in plane:
		jump = jump and _observe_at(axis, direction, ledge)
	return jump

func same_floor(hero: CharacterBody2D, surface) -> bool:
	return hero.detectors.platform.floors.surface.F == surface.F

func can_jump(ledge: Node2D, direction: Vector2i) -> bool:
	if ledge.surface.seat.has_hero: return false
	return same_floor(hero, ledge.surface) and observe(direction, ledge.pos)
