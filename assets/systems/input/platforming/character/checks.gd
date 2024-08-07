extends Node

const GAP: int = 64

var hero: CharacterBody2D
var directions: Array[Array] = [
	regulation(Vector2.AXIS_X), regulation(Vector2.AXIS_Y)
]

func inplace(ledge: float, subject: float) -> bool:
	return ledge >= subject - GAP and ledge <= subject + GAP

func regulation(axis: int) -> Array[Callable]:
	return [
		(func(ledge: Vector2):
			print(ledge[axis], " == ", hero.position[axis], " +- ", GAP)
			return inplace(ledge[axis], hero.position[axis])),
		(func(ledge: Vector2):
			print(ledge[axis], " > ", hero.position[axis])
			return ledge[axis] > hero.position[axis]),
		(func(ledge: Vector2):
			print(ledge[axis], " < ", hero.position[axis])
			return ledge[axis] < hero.position[axis])
	]

func _observe_at(axis: int, direction: Vector2i, ledge: Vector2):
	var power: int = direction[axis]
	directions[axis][power].call(ledge)

func observe(direction: Vector2i, ledge: Vector2) -> bool:
	var jump = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		jump = jump or _observe_at(axis, direction, ledge)
		print(" - JUMP: ", jump, " - AXIS: ", axis)
	return jump
