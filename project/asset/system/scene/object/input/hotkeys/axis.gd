extends Node

@export var left: Node
@export var right: Node

func get_axis() -> float:
	left.listen()
	right.listen()
	return right.switch.power - left.switch.power
