extends Node

var hero: CharacterBody2D

func _set_process(mode: ProcessMode):
	hero.processing.movement.process_mode = mode

func _should_stand_at(surface: Node2D) -> void:
	if surface.name == "ledge":
		_set_process(Node.PROCESS_MODE_DISABLED)
	else:
		_set_process(Node.PROCESS_MODE_INHERIT)
