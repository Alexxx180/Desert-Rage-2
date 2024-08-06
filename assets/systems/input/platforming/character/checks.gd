extends Node

@onready var hero: CharacterBody2D = get_node("../..")

const GAP: int = 4

func inplace(ledge: float, subject: float) -> bool:
	return ledge >= subject - GAP and ledge <= subject + GAP

func regulation(axis: int) -> Array[Callable]:
	return [
		(func(ledge: Vector2): return inplace(ledge[axis], hero.position[axis])),
		(func(ledge: Vector2): return ledge[axis] > hero.position[axis]),
		(func(ledge: Vector2): return ledge[axis] < hero.position[axis])
	]

func observe(axis: int, direction: Vector2i, ledge: Node2D):
	directions[axis][direction[axis]].call(ledge.position)

var directions: Array[Array] = [
	regulation(Vector2.AXIS_X), regulation(Vector2.AXIS_Y)
]
