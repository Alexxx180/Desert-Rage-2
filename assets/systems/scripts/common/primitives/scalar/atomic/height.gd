extends Node

var _F: int = 0
var F: int: get = _get_floor

func _get_floor() -> int:
	return _F

func set_floor(next: int) -> void:
	_F = next
