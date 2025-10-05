extends MouseManualControl

func is_near_gap(delta: Vector2) -> bool:
	return abs(delta.x) < GAP_ZONE

func get_direction() -> Vector2:
	return Vector2(hero.position.direction_to(mouse_target.position).x, 0)
