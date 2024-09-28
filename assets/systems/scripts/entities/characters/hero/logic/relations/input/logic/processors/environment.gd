extends Node

func set_control(input: Node, environment: Node) -> void:
	input.directing.connect(environment.surface.tracking.map.set_direction)
	input.directing.connect(environment.interaction.push.hero.set_direction)
