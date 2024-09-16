extends Node

class_name Tracker

var _position: Vector2 = Vector2.ZERO
var _direction: Vector2i = Vector2i.ZERO
var _contacts: Dictionary
var contact: Vector2: get = _get_current

func set_control_entity(box: Node2D) -> void:
	set_contacts(box.geometry.shape.size)

func set_position(next: Vector2) -> void: _position = next
func set_direction(next: Vector2i) -> void: _direction = next
func _get_current() -> Vector2: return get_contact(_direction)

func get_contact(current: Vector2i) -> Vector2:
	return _contacts[current].call()

func _point(right: Vector2, fill: Vector2) -> Callable:
	return (func(): return _position + right * fill)

func set_contacts(right: Vector2) -> void:
	_contacts = {}
	var sides: Dictionary = TrackingSides.fill()
	for side in sides.values():
		_contacts[side[0]] = _point(right, side[1])
