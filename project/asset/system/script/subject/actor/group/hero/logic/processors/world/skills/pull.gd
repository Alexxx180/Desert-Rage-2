extends Node

var hero: CharacterBody2D
var _grab: bool = false

func start_forward(box: CharacterBody2D) -> void:
	_grab = box.logic.processors.movement.seat.compare(hero)
	_grab = _grab or not hero.logic.detectors.world.skills.pull.ledge.is_colliding()
	if _grab:
		box.logic.processors.grab_box(hero)
		hero.weight += box.weight

func stop_forward(box: CharacterBody2D) -> void:
	if _grab:
		box.logic.processors.release_box(hero)
		hero.weight -= box.weight
