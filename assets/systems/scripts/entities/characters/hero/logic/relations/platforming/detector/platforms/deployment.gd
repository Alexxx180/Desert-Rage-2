extends Node

func set_control(deployment: DeploymentRaycast, processors: Node) -> void:
	var feet: Node = processors.input.platforming.jump.feet
	var surface: Node = processors.environment.surface
	
	deployment.prepare.connect(surface.find)
	deployment.deploy.connect(feet.placement)
