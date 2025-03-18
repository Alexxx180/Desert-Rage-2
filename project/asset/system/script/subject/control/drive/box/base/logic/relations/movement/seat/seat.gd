extends Node

@onready var booking: Node = $booking

func controls(box: CharacterBody2D, seat: Node) -> void:
	var stand: Node = box.logic.detectors.platforming.stand
	var floors: Node = box.logic.processors.movement.floors

	seat.place.standing.connect(box.view.enable_sync)
	seat.place.leaving.connect(box.view.disable_sync)

	stand.box = box
	stand.seat = seat
	seat.stand = stand
	seat.height = box.height

	booking.controls(seat)

	box.move.connect(seat.transport)
	floors.update_floor.connect(seat.set_floor)

	stand.body_entered.connect(seat.enable_stand)
	stand.body_exited.connect(seat.disable_stand)
