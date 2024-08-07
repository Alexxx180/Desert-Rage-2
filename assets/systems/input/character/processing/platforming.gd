extends Node

@onready var input: Node = get_node("../input")
@onready var platform = get_node("../../detectors/platform/ledge/platforming")

func _input(_event):
	print("Direction: ", input.direction)
	platform.perform_jump(input.direction)
