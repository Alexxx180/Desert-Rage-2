extends Node

@onready var booking: Node = $booking

func controls(platform: CharacterBody2D, seat: Node) -> void:
	var stand: Area2D = platform.logic.detectors.stand
	var floors: Node = platform.logic.processors.floors

	seat.place.standing.connect(platform.view.enable_sync)
	seat.place.leaving.connect(platform.view.disable_sync)

	stand.box = platform
	stand.seat = seat
	seat.stand = stand
	seat.height = platform.logic.processors.ride.surface.height

	booking.controls(seat)

	platform.logic.processors.ride.surface.move.connect(seat.transport)
	floors.update_floor.connect(seat.set_floor)

	stand.entered.connect(seat.enable_stand)
	stand.exited.connect(seat.disable_stand)
