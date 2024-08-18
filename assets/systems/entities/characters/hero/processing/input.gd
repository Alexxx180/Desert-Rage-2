extends Node

@onready var x: Node = $horizontal
@onready var y: Node = $vertical

var direction: Vector2i:
	get:
		return Vector2i(x.axis, y.axis)

func direction8(ix: float, iy: float) -> Vector2:
	return Vector2(ix, iy)
