extends Node

var _movement: Node
# var _platforming: Node
var _hero: CharacterBody2D
var collision_on: bool = true

func controls(hero: CharacterBody2D, feet: Node) -> void:
	_hero = hero
	_movement = hero.logic.processors.ui.input.movement
	# _platforming = hero.logic.processors.input.platforming

	feet.set_movement.connect(_set_movement)

func _set_movement(control: bool) -> void:
	# if not control:
	collision_on = control

	_hero.logic.processors.ui.input.gravity.context(control).collide_main()
	Processors.turn(_movement, control)
	_hero.logic.detectors.world.skills.pull.reset_monitoring(control) # false
	# Processors.turn(_movement, control)
	# Processors.turn(_platforming, !control)
