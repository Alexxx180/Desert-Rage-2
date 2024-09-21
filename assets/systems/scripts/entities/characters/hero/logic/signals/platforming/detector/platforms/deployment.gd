extends Node

func set_control(deployment: DeploymentRaycast, surface: Node) -> void:
	deployment.free_space.connect(surface.find_surface)
