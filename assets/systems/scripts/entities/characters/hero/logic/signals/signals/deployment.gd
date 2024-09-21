extends RefCounted

class_name HeroSignalsDeployment

static func apply(platforms: Node2D, processors: Node) -> void:
	var surface: Node = processors.environment.surface
	var input: Node = processors.input

	platforms.deployment.free_space.connect(surface.find_surface)
	platforms.overleap.body_entered.connect(input.on_ledge_encounter)
	surface.on_floors.connect(input.platforming.jump.placement)
