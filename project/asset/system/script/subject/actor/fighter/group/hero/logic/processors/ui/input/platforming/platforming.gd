extends Node

@onready var jump: Node = $jump
@onready var chains: Node = $chains

var gap: JumpTarget = JumpTarget.new()
var upland: JumpTarget = JumpTarget.new()

var animation: bool = false
var jumped: bool = false

func perform_jump() -> void:
	jumped = gap.decide(jump.floor_only) or upland.decide(jump.determine)
