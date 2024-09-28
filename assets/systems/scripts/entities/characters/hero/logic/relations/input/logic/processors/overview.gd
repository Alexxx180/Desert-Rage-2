extends Node

func set_control(input: Node, overview: Node) -> void:
	input.directing.connect(overview.directions.overview.set_direction)
