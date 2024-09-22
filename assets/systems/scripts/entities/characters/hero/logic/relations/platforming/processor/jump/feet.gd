extends Node

var _movement: Node

func set_control(processor: Node, movement: Node) -> void:
	_movement = movement
	processor.set_movement.connect(_set_movement)

func _set_movement(control: bool) -> void:
	Processors.turn(_movement, control)
