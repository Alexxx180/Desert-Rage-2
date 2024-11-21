extends Node

var _movement: Node

func controls(hero: CharacterBody2D, feet: Node, platforming: Node) -> void:
	var processors: Node = hero.logic.processors

	_movement = processors.input.movement

	feet.deployment = platforming.platforms.surface.deployment
	feet.surface = processors.environment.floors.tracker

	feet.balance.set_movement.connect(_set_movement)

func _set_movement(control: bool) -> void:
	Processors.turn(_movement, control)
