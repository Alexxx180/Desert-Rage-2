extends Node

var subject: Node2D
var geometry: CollisionShape2D

var basis: Vector2:
	get:
		return subject.position

var right: Vector2:
	get:
		return basis + geometry.shape.size

func sub(size: Node) -> Vector2:
	return right - size.basis

func set_control_entity(entity: Node2D):
	subject = entity
	geometry = entity.geometry
