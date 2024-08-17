extends Node

const GAP: int = 2

var previous: Vector2
var entity: Node2D
var seat: Node

func set_control_entity(box: Node2D):
	entity = box
	seat = box.interaction.seat
	remember_position()

func remember_position():
	previous = entity.position
	seat.remember()

func rollback_position():
	entity.position = previous
	seat.rollback()

func push(axis: int, velocity: int):
	remember_position()
	entity.position[axis] += velocity
	seat.move(axis, velocity)
