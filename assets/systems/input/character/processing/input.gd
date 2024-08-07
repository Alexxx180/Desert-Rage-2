extends Node

var x: float:
	get:
		return Input.get_axis("left", "right")

var y: float:
	get:
		return Input.get_axis("forward", "backward")

static func direction(ix: float, iy: float):
	return Vector2(ix, iy).normalized()

