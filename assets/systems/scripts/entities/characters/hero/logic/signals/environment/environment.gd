extends Node

@onready var surface: Node = $surface

func apply(environment: Node, input: Node) -> void:
	surface.set_control(environment.surface, input.platforming.jump)
