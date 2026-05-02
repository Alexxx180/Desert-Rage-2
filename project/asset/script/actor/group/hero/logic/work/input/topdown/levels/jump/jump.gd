extends Node

@onready var ledges: LedgeDeployment = LedgeDeployment.new()

# var jumped: bool = false
var surface: Node2D

func determine() -> void: # print("determine jump")
	if ledges.around():
		ledges.jump.velo.set_box(Def.ic("jump on the box %s", ledges.box))
		ledges.jump.jump(ledges.pos)
	else:
		ledges.jump.set_box(Def.ic("jump on the floor %s", Defaults.ENTITY))
		ledges.jump.deploy()

func perform(motion: Vector2) -> void:
	surface.deploy.set_direction(motion) # print("overleaping: ", surface.overleap.is_colliding(motion))
	if not ledges.jump.stable or surface.border.is_colliding(motion):
		determine()
#	else:
#		print("can't perform")
