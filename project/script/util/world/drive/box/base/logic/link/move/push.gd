extends Node

var _push: Node
var _hero

func _get_velocity(hero: CharacterBody2D) -> Node:
	return hero.to.topdown.move.act.velocity

func rides(_m):
	_push.apply_velocity(_hero.logic.stats.motion) # print("MOVING BOX: ", _hero.logic.stats.motion)

func _grab(hero: CharacterBody2D) -> void:
	_hero = hero
	hero.to.act.moving.connect(rides)
	hero.to.moves.set_move_action("pull")

func _release(hero: CharacterBody2D) -> void:
	hero.to.act.moving.disconnect(rides)
	hero.to.moves.set_move_action("go")
	_push.apply_velocity(Vector2.ZERO)

func controls(box: CharacterBody2D, push: Node) -> void:
	_push = push
	_push.box = box
	var work: Node = box.logic.work # processor.grab.connect(_grab) # processor.release.connect(_release)	
	push.directing.connect(work.press.set_direction) # push.forwarding.connect(box.push)
	push.weight = box.weight
