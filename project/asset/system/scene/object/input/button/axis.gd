extends Node

@onready var left: Node = $left
@onready var right: Node = $right

func get_axis() -> float:
	left.listen()
	right.listen()
	return right.switch.power - left.switch.power
