extends Node

signal debug_contact(contact)

@export var delimiter: int = 64

func correct(tracking: Node) -> Vector2:
	var contact: Vector2 = tracking.contact
	var direction: Vector2i = tracking.get_direction()

	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if fmod(contact[axis], delimiter) == 0:
			contact[axis] += direction[axis] * 0.1

	debug_contact.emit(contact)

	return contact
