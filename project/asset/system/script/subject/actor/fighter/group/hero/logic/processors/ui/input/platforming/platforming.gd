extends Node

@onready var jump: Node = $jump

var gap: JumpTarget = JumpTarget.new()
var upland: JumpTarget = JumpTarget.new()

var animation: bool = false
var jumped: bool = false

func perform_jump() -> void:
	print("GAP IS AVAILABLE! ", gap.available)
	print("UPLAND IS AVAILABLE! ", upland.available)
	jumped = gap.decide(jump.floor_only) or upland.decide(jump.determine)
