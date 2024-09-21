extends Node

class_name Tracker

var _contacts: Dictionary
var _position: Vector2 = Vector2.ZERO
var direction: Vector2i = Vector2i.ZERO
var contact: Vector2: get = _get_current
var center: Vector2: get = _get_center

func set_control_entity(box: Node2D) -> void:
	set_contacts(box.geometry.shape.size)

func set_position(next: Vector2) -> void: _position = next
func set_direction(next: Vector2i) -> void: direction = next

func _get_current() -> Vector2: return get_contact(direction)
func _get_center() -> Vector2: return get_contact(TrackingSides.CENTER)

func get_contact(current: Vector2i) -> Vector2:
	return _contacts[current].call(_position)

func set_contacts(right: Vector2) -> void:
	_contacts = TrackingSides.get_contacts(right)
