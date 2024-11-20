extends Node

var _movement: Node

func set_control(feet: Node, hero: CharacterBody2D) -> void:
	var platforms: Node = hero.logic.detectors.platforming.platforms
	var processors: Node = hero.logic.processors

	_movement = processors.input.movement

	feet.deployment = platforms.surface.deployment
	feet.surface = processors.environment.surface

	feet.balance.set_movement.connect(_set_movement)

func _set_movement(control: bool) -> void:
	Processors.turn(_movement, control)
