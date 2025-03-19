extends Node

enum { WORLD = 1, BORDERS = 2 }

var _movement: Node
var _hero: CharacterBody2D

func controls(hero: CharacterBody2D, balance: Node) -> void:
	_hero = hero
	_movement = hero.logic.processors.input.movement

	balance.set_movement.connect(_set_movement)
	balance.enable.connect(_disable_walls_collision)
	balance.disable.connect(_enable_walls_collision)

func _set_movement(control: bool) -> void:
	Processors.turn(_movement, control)

func _turn_walls_collision(value: bool) -> void:
	for mask in [WORLD, BORDERS]:
		_hero.set_collision_mask_value(mask, value)

func _enable_walls_collision() -> void:
	_turn_walls_collision(true)

func _disable_walls_collision() -> void:
	_turn_walls_collision(false)
