extends Node

var _F: int = 0
var F: int: get = _get_floor

var freeze: bool = false

func _get_floor() -> int:
	return _F

func set_floor(next: int) -> void:
	if (not freeze):
		_F = next

func set_box_floor(next: int) -> void:
	_F = next
