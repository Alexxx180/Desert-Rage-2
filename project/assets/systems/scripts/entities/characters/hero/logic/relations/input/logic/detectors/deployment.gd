extends Node

func set_control(input: Node, deployment: Node) -> void:
	input.directing.connect(deployment.walls.set_direction)
	input.directing.connect(deployment.ground.set_direction)
