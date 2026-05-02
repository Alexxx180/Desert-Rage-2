extends Node

var act: Node

@onready var input: Node = $input

func set_input() -> void:
	act.turn_around(input.get_vector())
