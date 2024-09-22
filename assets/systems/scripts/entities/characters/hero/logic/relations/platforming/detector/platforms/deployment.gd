extends Node

func set_control(deployment: DeploymentRaycast, processors: Node) -> void:
	var jump: Node = processors.input.platforming.jump
	var surface: Node = processors.environment.surface
	
	deployment.prepare.connect(surface.find)
	deployment.deploy.connect(jump.placement)
