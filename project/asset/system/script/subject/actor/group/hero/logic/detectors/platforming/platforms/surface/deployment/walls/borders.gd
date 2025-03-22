extends RayCast2D

const distance: int = 57

func set_direction(direction: Vector2) -> void:
	target_position = distance * direction
