extends ShapeCast2D

@onready var walls: Array[ShapeCast2D] = [$right, $left, self]

func is_landing(compare_to: float) -> bool:
	return compare_to == get_closest_collision_safe_fraction()

func get_target_pos() -> Vector2:
	return get_closest_collision_safe_fraction() * target_position
