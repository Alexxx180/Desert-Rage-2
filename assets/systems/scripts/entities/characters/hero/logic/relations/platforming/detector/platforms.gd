extends Node

@onready var ledges: Node = $ledges
@onready var overleap: Node = $overleap

func set_control(platforms: Node2D, processors: Node) -> void:
	var input: Node = processors.input
	var surface: Node = platforms.surface

	overleap.set_control(surface.overleap, input.platforming)
	ledges.set_control(platforms.ledges, input.platforming.jump.ledges)
