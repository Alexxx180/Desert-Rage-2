extends Node

@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

var jumped: bool = false
var surface: Node2D

func determine() -> void:
	print("determine jump")
	if ledges.around():
		print("jump on the box")
		feet.jump(ledges.pos)
	else:
		print("jump on the floor")
		feet.deploy()

func perform(motion: Vector2) -> void:
	surface.deployment.set_direction(motion)
	if feet.unstable or surface.overleap.is_colliding(motion):
		determine()
