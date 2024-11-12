extends Node

func set_control(input: Node, overleap: Node2D) -> void:
	input.directing.connect(overleap.gap.set_direction)
	input.directing.connect(overleap.upland.set_direction)
