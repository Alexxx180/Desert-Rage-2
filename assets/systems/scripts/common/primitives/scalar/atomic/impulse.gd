extends Node

var _impulse: int = 0
var impulse: int: get = _get_impulse

func _get_impulse() -> int:
	return _impulse

func set_impulse(next: int) -> void:
	_impulse = next
