extends Node

# var pos: Positioner = Positioner.new()

func set_control_entity(_hero: Node2D):
	pass
	# pos.entity = box
	# booking = box.interaction.seat.booking
	# box.booking.rollback.connect(pos.rollback)
	# box.booking.remember.connect(pos.remember)
	# box.booking.remember.emit()

func _direct(axis: int, motion: int) -> Vector2i:
	var direction: Vector2i = Vector2i.ZERO
	direction[axis] = clampi(motion, -1, 1)
	return direction

func _move(axis: int, velocity: int) -> Vector2:
	var motion: Vector2 = Vector2.ZERO
	motion[axis] = velocity
	return motion

func push(box: StaticBody2D, axis: int, velocity: int):
	#booking.remember.emit()
	box.directing.emit(_direct(axis, velocity))
	box.push(_move(axis, velocity))
	#booking.move.emit(axis, velocity)
