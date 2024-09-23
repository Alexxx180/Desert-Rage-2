extends Node

class_name Tracker

@onready var hero: Node = $position
@onready var map: Node = $direction

var _contacts: Dictionary
var contact: Vector2: get = _get_current

func set_contacts(right: Vector2) -> void:
	_contacts = TrackingSides.get_contacts(right)

func _get_current() -> Vector2:
	return get_contact(map.direction)

func get_position(space: DeploymentRaycast) -> Vector2:
	return get_contact(TrackingSides.CENTER) + space.walls.position

func get_contact(current: Vector2i) -> Vector2:
	return _contacts[current].call(hero.position)
