extends Node

@onready var feet: Node = $feet
@onready var ledges: Node = $ledges

var animation: bool = false
var jumped: bool = false
var gap: JumpTarget = JumpTarget.new()
var upland: JumpTarget = JumpTarget.new()
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

func perform() -> void:
	jumped = gap.decide(floor_only) or upland.decide(determine)
