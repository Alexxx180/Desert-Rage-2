extends RayCast2D

@export var distance: int = 128

func detected(direction: Vector2) -> bool:
	target_position = direction * distance
	return is_colliding()
