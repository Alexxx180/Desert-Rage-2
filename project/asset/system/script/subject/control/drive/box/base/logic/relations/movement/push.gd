extends Node

var _push: Node

func _grab(pull: Node):
	pull.apply_velocity.connect(_push.apply_velocity)

func _release(pull: Node):
	pull.apply_velocity.disconnect(_push.apply_velocity)
	_push.apply_velocity(Vector2.ZERO)

func controls(box: CharacterBody2D, push: Node) -> void:
	_push = push
	var processor: Node = box.logic.processors
	processor.grab.connect(_grab)
	processor.release.connect(_release)
	
	push.directing.connect(processor.press.set_direction)
	push.forwarding.connect(box.push)
	push.weight = box.weight
