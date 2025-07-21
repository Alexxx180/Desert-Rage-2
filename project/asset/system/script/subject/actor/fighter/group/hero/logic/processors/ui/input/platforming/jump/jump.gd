extends Node

@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

var border: TileMapLayer

func floor_only(control: JumpTarget) -> void:
	print("floor jump")
	feet.deploy()
	# if hero.logic.processors.ui.input.movement.
	control.available = false

func determine(control: JumpTarget) -> void:
	print("determine jump")
	if ledges.around():
		feet.jump(ledges.pos)
	else:
		feet.deploy(border)
	feet.set_midair(control)
