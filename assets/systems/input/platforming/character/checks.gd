extends Node

const NEUTRAL: int = 0
const GAP: int = 128

var hero: CharacterBody2D
var directions: Array[Array] = [
	regulation(Vector2.AXIS_X), regulation(Vector2.AXIS_Y)
]

func inplace(ledge: float, subject: float) -> bool:
	return ledge >= subject - GAP and ledge <= subject + GAP

func regulation(axis: int) -> Array[Callable]:
	return [
		(func(ledge: Vector2):
			# print(ledge[axis], " == ", hero.position[axis], " +- ", GAP)
			return inplace(ledge[axis], hero.position[axis])),
		(func(ledge: Vector2):
			print(ledge[axis], " > ", hero.position[axis])
			return ledge[axis] > hero.position[axis]),
		(func(ledge: Vector2):
			print(ledge[axis], " < ", hero.position[axis])
			return ledge[axis] < hero.position[axis])
	]

func _observe_at(axis: int, direction: Vector2i, ledge: Vector2) -> bool:
	var power: int = direction[axis]
	return directions[axis][power].call(ledge)

func observe(direction: Vector2i, ledge: Vector2) -> bool:
	var jump: bool = false
	var plane: Array[int] = []
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if direction[axis] != NEUTRAL:
			plane.push_back(axis)

	for axis in plane:
		var try: bool =_observe_at(axis, direction, ledge) 
		jump = jump or try
		# print(" - JUMP: ", jump, " - AXIS: ", axis)
	if jump:
		print("SHOULD JUMP")
	return jump
