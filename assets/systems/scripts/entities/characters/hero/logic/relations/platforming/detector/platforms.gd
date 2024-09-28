extends Node

@onready var ledges: Node = $ledges
@onready var overleap: Node = $overleap
@onready var deployment: Node = $deployment

func set_control(platforms: Node2D, processors: Node) -> void:
	var input: Node = processors.input
	var surface: Node = platforms.surface

	overleap.set_control(surface.overleap, input)
	ledges.set_control(platforms.ledges, input.platforming.jump.ledges)
	deployment.set_control(surface.deployment, processors)
