extends ShapeCast2D

# @export_range(0, 1, 1) var compare_to: int = 0
@onready var ground: Array[ShapeCast2D] = [$top, $bottom, self]

func is_landing(compare_to: float) -> bool:
	return compare_to == get_closest_collision_safe_fraction()

func get_target_pos() -> Vector2:
	return get_closest_collision_safe_fraction() * target_position
