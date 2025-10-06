extends Node

var _ride: Node
var _hero

func _get_velocity(hero: CharacterBody2D) -> Node:
	return hero.logic.work.input.movement.mode.velocity

func rides(_m):
	print("MOVING BOX: ", _hero.logic.stats.motion)
	_ride.apply_velocity(_hero.logic.stats.motion)

func _grab(hero: CharacterBody2D) -> void:
	# _get_velocity(hero).moving.connect(_ride.apply_velocity)
	_hero = hero
	_get_velocity(hero).moving.connect(rides)
	hero.view.animation.moves.set_move_action("pull")

func _release(hero: CharacterBody2D) -> void:
	_get_velocity(hero).moving.disconnect(rides)
	hero.view.animation.moves.set_move_action("go")
	_ride.apply_velocity(Vector2.ZERO)

func controls(platform: CharacterBody2D, ride: Node) -> void:
	_ride = ride
	var processor: Node = platform.logic.processors
	# processor.grab.connect(_grab)
	#  processor.release.connect(_release)
	
	# ride.directing.connect(processor.press.set_direction)
	_ride.forwarding.connect(platform.logic.processors.ride.surface.push)
