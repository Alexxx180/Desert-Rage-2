extends Node

const GAP: int = 2

var previous: Vector2
var entity: Node2D
var seat: Node

var direction: Vector2i

func get_direction() -> Vector2i: return direction

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
	direction = Vector2.ZERO
	direction[axis] = clampi(velocity, -1, 1)
	#print("PUSH: ", direction)
	#print("VEL: ", velocity)
	entity.position[axis] += velocity
	seat.move(axis, velocity)
