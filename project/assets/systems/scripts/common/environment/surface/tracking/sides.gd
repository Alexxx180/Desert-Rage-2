extends RefCounted

class_name TrackingSides

enum { BACK = -1, NONE = 0, FULL = 1 }

const CENTER = Vector2i.ZERO

static func _fill_angles() -> Dictionary:
	return {
#		TOP_LEFT = Vector2.ZERO, 
		TOP_LEFT = Vector2(BACK, BACK),
#		TOP_RIGHT = Vector2.RIGHT,
		TOP_RIGHT = Vector2(FULL, BACK),
#		BOTTOM_LEFT = Vector2.DOWN,
		BOTTOM_LEFT = Vector2(BACK, FULL),
		BOTTOM_RIGHT = Vector2.ONE,
		CENTER = Vector2.ZERO
	}

static func _fill_sides() -> Dictionary:
	const SEMI: float = 0.5
	return {
		TOP = [Vector2i.UP, Vector2(SEMI, BACK)],
		BOTTOM = [Vector2i.DOWN, Vector2(SEMI, FULL)],
		LEFT = [Vector2i.LEFT, Vector2(BACK, SEMI)],
		RIGHT = [Vector2i.RIGHT, Vector2(FULL, SEMI)],
	}

static func _point(right: Vector2, fill: Vector2) -> Callable:
	return (func(pos: Vector2): return pos + right * fill)

static func get_contacts(right: Vector2) -> Dictionary:
	var contacts: Dictionary = {}

	for angle in _fill_angles().values():
		contacts[Vector2i(angle.x, angle.y)] = _point(right, angle)

	for side in _fill_sides().values():
		contacts[side[0]] = _point(right, side[1])

	return contacts
