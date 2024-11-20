extends Node

@onready var platforms: Node = $platforms
@onready var floors: Node = $floors

func set_control(platforming: Node2D, processors: Node) -> void:
	var surface: Node = processors.environment.surface
	floors.set_control(platforming.floors, surface)
	platforms.set_control(platforming.platforms, processors)
