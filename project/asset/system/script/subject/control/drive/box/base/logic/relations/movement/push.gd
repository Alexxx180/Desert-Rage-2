extends Node

var _push: Node
var _hero

func _get_moving(hero: CharacterBody2D) -> Variant:
	return hero.logic.work.input.topdown.move.act.moving

func _get_velocity(hero: CharacterBody2D) -> Node:
	return hero.logic.work.input.movement.mode.velocity

func rides(_m):
	print("MOVING BOX: ", _hero.logic.stats.motion)
	_push.apply_velocity(_hero.logic.stats.motion)

func _grab(hero: CharacterBody2D) -> void:
	_hero = hero
	_get_moving(hero).connect(rides)
	hero.view.animation.moves.set_move_action("pull")

func _release(hero: CharacterBody2D) -> void:
	_get_moving(hero).disconnect(rides)
	hero.view.animation.moves.set_move_action("go")
	_push.apply_velocity(Vector2.ZERO)

func controls(box: CharacterBody2D, push: Node) -> void:
	_push = push
	_push.box = box
	var processor: Node = box.logic.processors
	processor.grab.connect(_grab)
	processor.release.connect(_release)
	
	push.directing.connect(processor.press.set_direction)
	push.forwarding.connect(box.push)
	push.weight = box.weight
