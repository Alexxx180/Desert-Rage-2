extends Node2D

@export var collision: CollisionShape2D

var rightpos: Vector2 : get = _get_right

func _get_right(): return position + collision.shape.size
