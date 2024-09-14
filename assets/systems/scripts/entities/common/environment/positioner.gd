extends RefCounted

class_name Positioner

var entity: Node2D
var placed: Vector2 = Vector2.ZERO

func remember() -> void:
	placed = entity.position

func rollback() -> void:
	entity.position = placed
