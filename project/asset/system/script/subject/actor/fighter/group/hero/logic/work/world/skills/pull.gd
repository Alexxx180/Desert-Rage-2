extends Node

var hero: CharacterBody2D
var _grab: bool = false
var boxes: Array[CharacterBody2D] = []

var velocity: Node:
	get: return hero.logic.work.input.topdown.move.act.velocity
var has_boxes: bool:
	get: return boxes.size() > 0

func set_animation(condition: bool, animation: String) -> void:
	if has_boxes: hero.view.animation.moves.set_move_action(animation)

func start_forward(box: CharacterBody2D) -> void:
	print("START FORWARD")
	boxes.push_back(box)
	# _grab = box.compare_height(hero) DEPRECATED
	var ledge: Node2D = hero.logic.see.world.skills.pull.ledge

	_grab = not ledge.is_colliding() # _grab or
	if _grab:
		velocity.weight += box.weight

func stop_forward(box: CharacterBody2D) -> void:
	boxes.erase(box)
	print("STOP FORWARD")
	if _grab:
		velocity.weight = max(0, velocity.weight - box.weight)
		box.logic.processors.movement.push.apply_velocity(Vector2.ZERO)

func apply_velocity(velocity: Vector2) -> void:
	for box in boxes:
		box.logic.processors.movement.push.apply_velocity(velocity)
	if has_boxes:
		hero.view.animation.moves.set_move_action("pull")
	else:
		hero.view.animation.moves.set_move_action("go")
