extends Node

@onready var booking: Node = $booking

func controls(platform: CharacterBody2D, seat: Node) -> void:
	var stand: Area2D = platform.logic.see.stand
	var floors: Node = platform.logic.work.floors
	var ride: Node = platform.logic.work.ride

	seat.place.standing.connect(platform.view.enable_sync)
	seat.place.leaving.connect(platform.view.disable_sync)

	stand.box = platform
	stand.seat = seat
	seat.place.entity = platform
	seat.place.stand = stand
	seat.height = ride.surface.height

	booking.controls(seat)

	platform.logic.work.ride.surface.move.connect(seat.transport)
	# floors.update_floor.connect(seat.set_floor)

	stand.entered.connect(seat.enable_stand)
	stand.entered.connect(func(hero):
		ride.hero_entered(hero)
		hero.to.act.velocity.forget()
		#  # FOR DIRECTED PLATFORMS
		)
	stand.exited.connect(seat.disable_stand)
	stand.exited.connect(func(_hero):
		ride.surface.push(Vector2.ZERO)
		ride.surface.free_engine())
