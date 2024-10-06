extends Node

class_name Tracker

@onready var hero: CharacterBody2D
@onready var map: Node = $direction

var _contacts: Dictionary
var contact: Vector2: get = _get_current

func set_contacts(right: Vector2) -> void:
	_contacts = TrackingSides.get_contacts(right)

func _get_current() -> Vector2:
	return get_contact(map.direction)

func get_position(ground: Node2D) -> Vector2:
	return get_contact(TrackingSides.CENTER) + ground.previous

func get_contact(current: Vector2i) -> Vector2:
	return _contacts[current].call(hero.position)
