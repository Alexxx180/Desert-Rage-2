extends Node

class_name Tracker

@onready var hero: Node = $position
@onready var map: Node = $direction

var _contacts: Dictionary
var contact: Vector2: get = _get_current
var center: Vector2: get = _get_center

func set_control_entity(entity: Node2D) -> void:
	var right: Vector2 = entity.geometry.shape.size
	_contacts = TrackingSides.get_contacts(right)

func _get_current() -> Vector2:
	return get_contact(map.direction)

func _get_center() -> Vector2:
	return get_contact(TrackingSides.CENTER)

func get_contact(current: Vector2i) -> Vector2:
	return _contacts[current].call(hero.position)
