extends Node

@onready var jump: Node = $jump

var gap: JumpTarget = JumpTarget.new()
var upland: JumpTarget = JumpTarget.new()

var animation: bool = false
var jumped: bool = false
var ledges: TileMapLayer

func perform_jump() -> void:
	jumped = gap.jump_on(ledges) or upland.jump_on(ledges)
