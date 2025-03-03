extends RefCounted

class_name FlowConductor

static func get_offset() -> Array[Vector2i]:
	return [Vector2i(0, -1), Vector2i(0, 1),  Vector2i(-1, 0), Vector2i(1, 0)]

static func around(map_coords: Vector2i, context: Dictionary, check: Callable) -> bool:
	var search: bool = true
	var offset: Array[Vector2i] = get_offset()
	var i: int = offset.size()
	while i > 0 and search:
		i -= 1
		search = check.call(map_coords + offset[i], context)
	return search
