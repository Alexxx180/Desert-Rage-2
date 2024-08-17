extends Node

@onready var x: Node = $horizontal
@onready var y: Node = $vertical

func direction() -> Vector2i:
	return direction8(x.axis, y.axis)

func direction8(ix: float, iy: float) -> Vector2:
	return Vector2(ix, iy)
