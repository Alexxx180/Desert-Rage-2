extends ShapeCast2D

const distance: int = 114
const pos: Vector2 = Vector2(distance, distance)

@onready var _half: Vector2 = shape.size / 2

func set_direction(direction: Vector2) -> void:
	position = direction * (pos + _half)
