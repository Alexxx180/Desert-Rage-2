extends Node

func set_control(input: Node, overview: Node) -> void:
	input.directing.connect(overview.directions.eyes.set_direction)
