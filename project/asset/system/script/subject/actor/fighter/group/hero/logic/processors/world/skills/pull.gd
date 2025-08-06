extends Node

var hero: CharacterBody2D
var _grab: bool = false
var boxes: Array[CharacterBody2D] = []

var velocity: Node:
	get: return hero.logic.processors.ui.input.movement.type.velocity

func start_forward(box: CharacterBody2D) -> void:
	boxes.push_back(box)
	_grab = box.compare_height(hero)
	_grab = _grab or not hero.logic.detectors.world.skills.pull.ledge.is_colliding()
	if _grab:
		box.logic.processors.grab_box(hero)
		velocity.weight += box.weight

func stop_forward(box: CharacterBody2D) -> void:
	boxes.remove(box)
	if _grab:
		box.logic.processors.release_box(hero)
		velocity.weight -= box.weight
