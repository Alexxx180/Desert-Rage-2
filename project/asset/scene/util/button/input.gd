extends Node

@onready var x: Node = $x
@onready var y: Node = $y

func get_vector() -> Vector2:
	return Vector2(x.get_axis(), y.get_axis())

var act: Node

@onready var input: Node = $input

func get_axis() -> float:
	left.listen()
	right.listen()
	return right.switch.power - left.switch.power

func set_input() -> void:
	act.turn_around(input.get_vector())
