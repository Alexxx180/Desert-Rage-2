extends Node

func set_control(input: Node, environment: Node) -> void:
	input.directing.connect(environment.surface.tracking.set_direction)
	input.directing.connect(environment.interaction.push.set_direction)
