extends Node

var hero: CharacterBody2D
var _grab: bool = false
var boxes: Array[CharacterBody2D] = []

var velocity: Node:
	get: return hero.logic.work.input.topdown.move.act.velocity

func start_forward(box: CharacterBody2D) -> void:
	boxes.push_back(box)
	# _grab = box.compare_height(hero) DEPRECATED
	_grab = not hero.logic.see.world.skills.pull.ledge.is_colliding() # _grab or
	if _grab:
		box.logic.processors.grab_box(hero)
		velocity.weight += box.weight

func stop_forward(box: CharacterBody2D) -> void:
	boxes.erase(box)
	if _grab:
		box.logic.processors.release_box(hero)
		velocity.weight -= box.weight
