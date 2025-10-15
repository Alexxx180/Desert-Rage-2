extends Node

@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

var jumped: bool = false
var surface: Node2D

func determine() -> void:
	# print("determine jump")
	if ledges.around():
		print("jump on the box")
		feet.set_box(ledges.box)
		feet.jump(ledges.pos)
	else:
		print("jump on the floor")
		feet.set_box(Defaults.ENTITY)
		feet.deploy()

func perform(motion: Vector2) -> void:
	surface.deploy.set_direction(motion) # print("overleaping: ", surface.overleap.is_colliding(motion))
	if feet.unstable or surface.border.is_colliding(motion):
		determine()
	else:
		print("can't perform")
