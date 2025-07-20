extends Node

var _push: Node

func _grab(hero: CharacterBody2D) -> void:
	hero.logic.processors.ui.input.movement.mode.velocity.moving.connect(_push.apply_velocity)
	hero.view.animation.moves.set_move_action("pull")

func _release(hero: CharacterBody2D) -> void:
	hero.logic.processors.ui.input.movement.mode.velocity.moving.disconnect(_push.apply_velocity)
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
