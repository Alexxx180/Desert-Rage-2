extends Node

@onready var overleap: Node = $overleap
@onready var deployment: Node = $deployment
@onready var environment: Node = $environment
@onready var overview: Node = $overview

func set_control(input: Node, logic: Node) -> void:
	var platforms: Node = logic.detectors.platforming.platforms

	overleap.set_control(input, platforms.surface.overleap)
	deployment.set_control(input, platforms.surface.deployment)

	environment.set_control(input, logic.processors.environment)

	overview.set_control(input, input.platforming.jump.overview)