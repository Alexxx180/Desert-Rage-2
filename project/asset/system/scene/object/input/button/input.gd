extends Node

@onready var x: Node = $x
@onready var y: Node = $y

func get_vector() -> Vector2:
	return Vector2(x.get_axis(), y.get_axis())
