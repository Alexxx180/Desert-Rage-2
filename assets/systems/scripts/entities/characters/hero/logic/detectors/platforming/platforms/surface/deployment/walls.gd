extends ShapeCast2D

@onready var _half: Vector2 = shape.size / 2

func contact() -> Vector2: return position + _half

func freed(surface: RayCast2D, direction: Vector2) -> bool:
	position = surface.target_position
	position += _half * direction
	return not is_colliding()
