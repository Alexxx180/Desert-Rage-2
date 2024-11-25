extends RayCast2D

const distance: int = 114

func set_direction(direction: Vector2) -> void:
	target_position = direction * distance
