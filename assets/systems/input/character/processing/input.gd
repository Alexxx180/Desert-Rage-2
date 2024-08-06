extends Node

var x: float:
	get:
		return Input.get_axis("left", "right")

var y: float:
	get:
		return Input.get_axis("forward", "backward")

var direction: Vector2i:
	get:
		return Vector2(x, y).normalized()
