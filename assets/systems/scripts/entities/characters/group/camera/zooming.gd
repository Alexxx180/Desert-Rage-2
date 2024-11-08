extends RefCounted

class_name CameraZooming

const zooming: float = 0.5
const minimum: float = 0.5
const maximum: float = 5.0

static func zoom() -> float:
	return Input.get_axis("view_left", "view_right") * zooming

static func new_zoom(original: float, value: float) -> Vector2:
	value = clampf(original + value, minimum, maximum)
	return Vector2(value, value)
