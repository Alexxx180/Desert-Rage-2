extends Node

var _movement: Node
# var _platforming: Node
var _hero: CharacterBody2D
var collision_on: bool = true

func controls(hero: CharacterBody2D, balance: Node) -> void:
	_hero = hero
	_movement = hero.logic.processors.ui.input.movement
	# _platforming = hero.logic.processors.input.platforming

	balance.set_movement.connect(_set_movement)

func _set_movement(control: bool) -> void:
	# if not control:
	_turn_walls_collision(control)
	Processors.turn(_movement, control)
	_hero.logic.detectors.world.skills.pull.reset_monitoring(control) # false
	# Processors.turn(_movement, control)
	# Processors.turn(_platforming, !control)

func _turn_walls_collision(value: bool) -> void:
	_hero.logic.processors.ui.input.gravity.turn_walls_collision(value)
	collision_on = value
