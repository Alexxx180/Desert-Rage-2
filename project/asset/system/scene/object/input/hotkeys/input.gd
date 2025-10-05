extends Node

@export var x: Node
@export var y: Node

func get_axis() -> Vector2:
	return Vector2(x.get_axis(), y.listen())
