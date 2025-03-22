extends Node

class_name SurfaceTracker

var entity: CharacterBody2D
var contact_zone: Area2D

var _contact: Vector2 = Vector2.ZERO
var contact: Vector2:
	get: return _contact

func set_contact() -> void:
	_contact = entity.position

func track(ground: Node2D) -> Vector2:
	return entity.position + ground.position
