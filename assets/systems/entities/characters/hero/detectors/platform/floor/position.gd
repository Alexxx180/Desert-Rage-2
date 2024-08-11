extends Node

var hero: CharacterBody2D

func _set_process(mode: ProcessMode):
	hero.processing.movement.process_mode = mode

func _should_stand_at(surface: Node2D) -> void:
	if "surface" in surface:
		surface.box.set_stand(hero)
		surface.box.switch_stand(hero, true)
		_set_process(Node.PROCESS_MODE_DISABLED)
	else:
		_set_process(Node.PROCESS_MODE_INHERIT)

func _disable_stand(surface: Node2D) -> void:
	if "surface" in surface:
		surface.box.switch_stand(hero, false)
