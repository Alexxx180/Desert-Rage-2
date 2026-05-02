extends Node

@onready var booking: Node = $booking

func controls(platform: CharacterBody2D, seat: Node) -> void:
	var stand: StaticBody2D = platform.logic.see.stand
	stand.box = platform
	var floors: Node = platform.logic.work.floors
	var ride: Node = platform.logic.work.ride

	#seat.place.standing.connect(platform.view.enable_sync)
	#seat.place.leaving.connect(platform.view.disable_sync)

	
	#stand.seat = seat
	#seat.place.entity = platform
	#seat.place.stand = stand
	seat.height = platform.height

	booking.controls(seat)

	# ride.engine.move.connect(seat.transport)
	ride.engine.speed = platform.speed
	# floors.update_floor.connect(seat.set_floor)

	#stand.entered.connect(seat.enable_stand)
	"""
	stand.entered.connect(func(hero):
		ride.hero_entered(hero)
		hero.to.act.velocity.forget()
		#  # FOR DIRECTED PLATFORMS
		)
	"""
	#stand.exited.connect(seat.disable_stand)
	"""
	stand.exited.connect(func(_hero):
		ride.engine.push(Vector2.ZERO)
		ride.engine.set_busy(ride.engine.FREE))
	"""
