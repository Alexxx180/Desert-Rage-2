extends Node

@export var delimiter: int = 64

func correct(contact: Vector2, direction: Vector2) -> Vector2:
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if fmod(contact[axis], delimiter) == 0:
			contact[axis] += direction[axis] * 0.1
	return contact
