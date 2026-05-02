extends Node

var _ride: Node
var _hero

func rides(_m): #print("MOVING BOX: ", _hero.logic.stats.motion)
	_ride.apply_velocity(_hero.logic.stats.motion)

func _grab(hero: CharacterBody2D) -> void: # _get_velocity(hero).moving.connect(_ride.apply_velocity)
	_hero = hero
	hero.to.act.velocity.moving.connect(rides)
	hero.to.moves.set_move_action("pull")

func _release(hero: CharacterBody2D) -> void:
	hero.to.act.velocity.moving.disconnect(rides)
	hero.to.moves.set_move_action("go")
	_ride.apply_velocity(Vector2.ZERO)

func controls(platform: CharacterBody2D, ride: Node) -> void:
	_ride = ride
	var work: Node = platform.logic.work
	ride.platform = platform
	#ride.seat = work.seat
	# ride.surface.seat = work.seat
	#ride.surface.engine = ride.engine
	# ride.surface.igniting = ride.igniting
	ride.caution = platform.logic.see.caution
	ride.engine.platform = platform #  platform
	
	#ride.surface.ignite_engine()
	# processor.grab.connect(_grab) #  processor.release.connect(_release) # ride.directing.connect(processor.press.set_direction)
	_ride.forwarding.connect(ride.engine.push)
