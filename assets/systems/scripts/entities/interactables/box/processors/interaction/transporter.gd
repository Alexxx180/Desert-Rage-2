extends Node

signal directing(direction: Vector2i)

var direction: Vector2i
var booking: Node
var pos: Positioner = Positioner.new()

func set_control_entity(box: Node2D):
	pos.entity = box
	booking = box.interaction.seat.booking
	booking.rollback.connect(pos.rollback)
	booking.remember.connect(pos.remember)
	booking.remember.emit()

func _direct(axis: int, side: int):
	direction = Vector2.ZERO
	direction[axis] = side
	directing.emit(direction)

func push(axis: int, velocity: int):
	booking.remember.emit()
	_direct(axis, clampi(velocity, -1, 1))
	pos.entity.position[axis] += velocity
	booking.move.emit(axis, velocity)
