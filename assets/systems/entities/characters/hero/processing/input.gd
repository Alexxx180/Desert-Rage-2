extends Node

@onready var x: Node = $horizontal
@onready var y: Node = $vertical

var _direction: Vector2i = Vector2i.ZERO
var direction: Vector2i:
	get:
		_direction = Vector2i(x.axis, y.axis)
		return _direction

var previous: Vector2i:
	get: return _direction

func direction8(ix: float, iy: float) -> Vector2:
	return Vector2(ix, iy)
