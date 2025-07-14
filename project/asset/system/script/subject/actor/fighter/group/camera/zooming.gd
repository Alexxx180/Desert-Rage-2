extends RefCounted

class_name CameraZooming

var zooming: float
var minimum: float
var maximum: float

func _init() -> void: dungeon()

func set_zoom(zmin: float, z: float, zmax: float) -> void:
	zooming = z
	minimum = zmin
	maximum = zmax

func overworld() -> void: set_zoom(0.1, 0.05, 0.5)

func dungeon() -> void: set_zoom(0.5, 0.1, 1.5)

func zoom() -> float:
	return Input.get_axis("view_left", "view_right") * zooming

func new_zoom(original: float, value: float) -> Vector2:
	value = clampf(original + value, minimum, maximum)
	return Vector2(value, value)
