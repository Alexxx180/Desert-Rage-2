extends RayCast2D

@export var distance: int = 128

var _direction: Vector2 = Vector2.ZERO

func head(size: Vector2) -> Vector2:
	return target_position + size * _direction

func detected(direction: Vector2) -> bool:
	_direction = direction
	target_position = direction * distance
	return is_colliding()
