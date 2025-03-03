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



static func _around(map_coords: Vector2i, context: Dictionary, check: Callable) -> bool:
	var search: bool = true
	var axis: int = Vector2.AXIS_Y

	while search and axis >= Vector2.AXIS_X:
		var offset: int = 3

		while search and offset > -1:
			offset -= 2
			var near: Vector2i = map_coords
			near[axis] += offset
			search = check.call(near, context)

		axis -= 1

	return search
