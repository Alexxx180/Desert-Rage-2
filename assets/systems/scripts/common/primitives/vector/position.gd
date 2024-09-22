extends Node

var _position: Vector2 = Vector2.ZERO
var position: Vector2: get = _get_position

func _get_position() -> Vector2:
	return _position

func set_position(next: Vector2) -> void:
	_position = next
