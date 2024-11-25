extends Node

var _direction: Vector2i = Vector2i.ZERO
var direction: Vector2i: get = _get_direction

func _get_direction() -> Vector2i:
	return _direction

func set_direction(next: Vector2i) -> void:
	_direction = next
