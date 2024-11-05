extends Node

var _impulse: float = 0
var impulse: float: get = _get_impulse

func _get_impulse() -> float:
	return _impulse

func set_impulse(next: float) -> void:
	_impulse = next
