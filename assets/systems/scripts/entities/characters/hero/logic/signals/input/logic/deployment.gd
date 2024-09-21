extends Node

func set_control(input: Node, deployment: Node) -> void:
	input.directing.connect(deployment.search)
