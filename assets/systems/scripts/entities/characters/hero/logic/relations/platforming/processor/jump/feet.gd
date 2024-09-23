extends Node

var _movement: Node

func set_control(processor: Node, hero: CharacterBody2D) -> void:
	_movement = hero.logic.processors.input.movement
	processor.set_movement.connect(_set_movement)

func _set_movement(control: bool) -> void:
	Processors.turn(_movement, control)
