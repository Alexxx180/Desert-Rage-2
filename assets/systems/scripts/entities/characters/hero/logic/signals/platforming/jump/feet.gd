extends Node

func set_control(input: Node, processor: Node) -> void:
	processor.set_movement.connect(input.set_movement)
