extends Node

@onready var surface: Node = $surface
@onready var push: Node = $push

func apply(environment: Node, logic: Node) -> void:
	var platforming: Node = logic.processors.input.platforming

	surface.set_control(environment.surface, platforming.jump)
	push.set_control(environment.push, logic.stats)
