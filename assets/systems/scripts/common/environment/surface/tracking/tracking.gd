extends Node

class_name Tracker

@onready var entity: CharacterBody2D
@onready var map: Node = $direction

var _contacts: Dictionary
var contact: Vector2: get = _get_current

func set_contacts(right: Vector2) -> void:
	_contacts = TrackingSides.get_contacts(right)

func get_direction() -> Vector2i:
	var n: Vector2 = entity.velocity.normalized()
	return Vector2i(round(n.x), round(n.y))

func _get_current() -> Vector2:
	return get_contact(get_direction())

func get_position(ground: Node2D) -> Vector2:
	return get_contact(TrackingSides.CENTER) + ground.previous

func get_contact(current: Vector2i) -> Vector2:
	#print("ENTITY: ", entity.name)
	return _contacts[current].call(entity.position)
