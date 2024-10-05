extends ShapeCast2D

@onready var _half: Vector2 = shape.size / 2

func contact() -> Vector2:
	return position + _half

func present(surface: RayCast2D) -> bool:
	position = surface.head(_half)
	return is_colliding()
