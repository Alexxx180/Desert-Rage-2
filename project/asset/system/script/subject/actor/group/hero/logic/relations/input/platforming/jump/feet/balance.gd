extends Node

enum { WORLD = 1, BORDERS = 2, BOX = 5 }


var _movement: Node
# var _platforming: Node
var _hero: CharacterBody2D

func controls(hero: CharacterBody2D, balance: Node) -> void:
	_hero = hero
	_movement = hero.logic.processors.input.movement
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
	print("TURN MOVEMENT TO: ", value)
	for mask in [WORLD, BORDERS, BOX]:
		_hero.set_collision_mask_value(mask, value)
