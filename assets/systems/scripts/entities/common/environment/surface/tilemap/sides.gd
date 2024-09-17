extends RefCounted

class_name TrackingSides

enum { BACK = -1, NONE = 0, FULL = 1 }

const CENTER = Vector2i.ZERO

static func fill() -> Dictionary:

	var SEMI: float = 0.5

	return {
		TOP_LEFT = [Vector2i(BACK, BACK), Vector2.ZERO],
		TOP_RIGHT = [Vector2i(FULL, BACK), Vector2.RIGHT],
		BOTTOM_LEFT = [Vector2i(BACK, FULL), Vector2.DOWN],
		BOTTOM_RIGHT = [Vector2i.ONE, Vector2.ONE],

		CENTER = [Vector2i.ZERO, Vector2(SEMI, SEMI)],
		TOP = [Vector2i.UP, Vector2(SEMI, NONE)],
		BOTTOM = [Vector2i.DOWN, Vector2(SEMI, FULL)],
		LEFT = [Vector2i.LEFT, Vector2(NONE, SEMI)],
		RIGHT = [Vector2i.RIGHT, Vector2(FULL, SEMI)],
	}
