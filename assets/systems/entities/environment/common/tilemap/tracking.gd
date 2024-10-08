extends Node

class_name Tracker

static func print_p(position: Vector2, right: Vector2) -> void:
	print("POS: ", position)
	print("RHT: ", right)

static func pointing(position: Vector2, right: Vector2) -> Vector2:
	#print_p(position, right)
	return position + right

var entity: Node2D
var velocity: Node
var _contacts: Dictionary

var direction: Vector2i:
	get: return velocity.get_direction()

var contact: Vector2:
	get: return get_contact(direction)

func get_contact(current: Vector2i):
	return _contacts[current].call()

func _point(right: Vector2, fill: Vector2) -> Callable:
	return (func(): return Tracker.pointing(entity.position, right * fill))

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
		Vector2i.ZERO: _point(right, Vector2(CENTER, CENTER)),
		Vector2i.UP: _point(right, Vector2(CENTER, NONE)),
		Vector2i.DOWN: _point(right, Vector2(CENTER, FULL)),
		Vector2i.LEFT: _point(right, Vector2(NONE, CENTER)),
		Vector2i.RIGHT: _point(right, Vector2(FULL, CENTER)),
	}
