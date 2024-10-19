extends Node

@onready var booking: Node = $booking

func set_control(box: StaticBody2D, seat: Node) -> void:
	var stand: Node = box.logic.detectors.platforming.stand
	var surface: Node = box.logic.processors.movement.surface

	seat.place.standing.connect(box.view.standing)
	seat.place.leaving.connect(box.view.leaving)
	booking.set_control(seat)

	box.move.connect(seat.transport)
	surface.floors.update.connect(seat.set_floor)

	stand.body_entered.connect(seat.enable_stand)
	stand.body_exited.connect(seat.disable_stand)
