extends Node

@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

var animation: bool = false
var jumped: bool = false
var available: bool = false
# var gap: JumpTarget = JumpTarget.new()
# var upland: JumpTarget = JumpTarget.new()
var surface: Node2D
var walls: Node2D
var border: TileMapLayer

"""
func floor_only(control: JumpTarget) -> void:
	print("floor jump")
	feet.deploy()
	# if hero.logic.processors.ui.input.movement.
	control.available = false
"""

func determine() -> void:
	print("determine jump")
	if ledges.around():
		feet.jump(ledges.pos)
	else:
		feet.deploy(border)
	feet.set_midair(self)

func perform(motion: Vector2) -> void:
	surface.deployment.set_direction(motion)
	if surface.overleap.is_colliding(motion):
		determine()
		jumped = available
