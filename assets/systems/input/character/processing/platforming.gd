extends Node

const NEUTRAL: int = 0

@onready var input: Node = get_node("../input")
@onready var platform = get_node("../../detectors/platform/ledge/platforming")

func _input(_event):
	var x: float = input.x
	var y: float = input.y
	if x != NEUTRAL or y != NEUTRAL:
		var direction: Vector2i = input.direction(x, y)
		print("Direction: ", direction)
		platform.perform_jump(direction)
