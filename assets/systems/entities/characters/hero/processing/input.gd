extends Node

@onready var x: Node = $horizontal
@onready var y: Node = $vertical

var previous: Vector2i = Vector2i.ZERO
var direction: Vector2i:
	get:
		previous = Vector2i(x.axis, y.axis)
		return previous

func direction8(ix: float, iy: float) -> Vector2:
	return Vector2(ix, iy)
