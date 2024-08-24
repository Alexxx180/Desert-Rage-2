extends Node

var entity: Node2D
var _contacts: Dictionary

var direction: Vector2i:
	get: return entity.processing.input.previous

var contact: Vector2:
	get: return _contacts[direction].call()

func _point(right: Vector2, fill: Vector2) -> Callable:
	return (func() -> Vector2: return entity.position + right * fill)

func set_contacts(right: Vector2) -> void:
	const FULL: int = 1
	const BACK: int = -1

	const TOP_LEFT: Vector2i = Vector2i(BACK, BACK)
	const BOTTOM_LEFT: Vector2i = Vector2i(BACK, FULL)
	const TOP_RIGHT: Vector2i = Vector2i(FULL, BACK)
	const BOTTOM_RIGHT: Vector2i = Vector2i.ONE

	const NONE: int = 0
	const CENTER: float = 0.5

	_contacts = {
		TOP_LEFT: _point(right, Vector2.ZERO),
		BOTTOM_LEFT: _point(right, Vector2.DOWN),
		TOP_RIGHT: _point(right, Vector2.RIGHT),
		BOTTOM_RIGHT: _point(right, Vector2.ONE),
		Vector2i.UP: _point(right, Vector2(CENTER, NONE)),
		Vector2i.DOWN: _point(right, Vector2(CENTER, FULL)),
		Vector2i.LEFT: _point(right, Vector2(NONE, CENTER)),
		Vector2i.RIGHT: _point(right, Vector2(FULL, CENTER)),
	}
