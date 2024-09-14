extends Node

class_name Tracker

var entity: Node2D
var direction: Vector2i

var _contacts: Dictionary
var contact: Vector2:
	get: return get_contact(direction)

func set_direction(next: Vector2i): direction = next
func get_contact(current: Vector2i): return _contacts[current].call()

func _point(right: Vector2, fill: Vector2) -> Callable:
	return (func(): return entity.position + right * fill)

func set_contacts(right: Vector2) -> void:
	_contacts = {}
	var sides: Dictionary = TrackingSides.fill()
	for side in sides.values():
		_contacts[side[0]] = _point(right, side[1])
