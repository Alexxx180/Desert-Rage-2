extends RefCounted

class_name FlowConductor

enum { NONE = -1, SPARK = 0 }

const TILE: Dictionary = {
	"PUDDLE": { "OFF": Vector2i(2, 2), "ON": Vector2i(3, 2), "ID": 4 },
	"SOURCE": { "OFF": Vector2i(3, 5), "ON": Vector2i(4, 5), "ID": 2 }
}

static func around(map_coords: Vector2i, context: Dictionary, check: Callable) -> bool:
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
