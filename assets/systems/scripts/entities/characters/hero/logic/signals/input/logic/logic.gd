extends Node

@onready var environment: Node = $environment
@onready var deployment: Node = $deployment
@onready var overview: Node = $overview

func set_control(input: Node, logic: Node) -> void:
	var surface: Node = logic.detectors.platforming.platforms.surface

	deployment.set_control(input, surface.deployment)
	environment.set_control(input, logic.processors.environment)
	overview.set_control(input, input.platforming.jump.overview)
