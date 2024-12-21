extends ShapeCast2D

class_name AreaDetector

@export var offset: int = 0

const distance: int = 114
const pos: Vector2 = Vector2(distance, distance)

@onready var _half: Vector2 = shape.size / 2

func set_direction(direction: Vector2) -> void:
	var next: Vector2 = direction * (pos + _half)
	var off: Vector2 = next.orthogonal().normalized() * offset
	position = next + off
