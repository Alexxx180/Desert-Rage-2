extends Node

var _push: Node

func _get_moving(hero: CharacterBody2D) -> Variant:
	return hero.logic.processors.ui.input.movement.type.velocity.moving

func _grab(hero: CharacterBody2D) -> void:
	_get_moving(hero).connect(_push.apply_velocity)
	hero.view.animation.moves.set_move_action("pull")

func _release(hero: CharacterBody2D) -> void:
	_get_moving(hero).disconnect(_push.apply_velocity)
	hero.view.animation.moves.set_move_action("go")
	_push.apply_velocity(Vector2.ZERO)

func controls(box: CharacterBody2D, push: Node) -> void:
	_push = push
	var processor: Node = box.logic.processors
	processor.grab.connect(_grab)
	processor.release.connect(_release)
	
	push.directing.connect(processor.press.set_direction)
	push.forwarding.connect(box.push)
	push.weight = box.weight
