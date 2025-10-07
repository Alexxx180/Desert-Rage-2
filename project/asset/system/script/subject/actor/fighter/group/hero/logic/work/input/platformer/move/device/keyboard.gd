extends Node

var act: Node

@onready var input: Node = $input

func set_input() -> void:
	act.turn_around(Vector2(input.get_axis(), 0))
